const functions = require('firebase-functions');
const Stripe = require('stripe');
const cors = require('cors')({ origin: true });
const admin = require('firebase-admin');

admin.initializeApp();
// Read secrets from Firebase Functions runtime config
// Set with: firebase functions:config:set stripe.secret="sk_test_xxx" stripe.webhook_secret="whsec_xxx"
const stripe = new Stripe(functions.config().stripe.secret, {
  apiVersion: '2022-11-15',
});

exports.createPaymentSheet = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      const { uid, email } = req.body;

      // Create customer if doesn't exist
      let customer;
      const customers = await stripe.customers.list({ email });
      if (customers.data.length > 0) {
        customer = customers.data[0];
      } else {
        customer = await stripe.customers.create({ email });
      }

      // Create ephemeral key
      const ephemeralKey = await stripe.ephemeralKeys.create(
        { customer: customer.id },
        { apiVersion: '2022-11-15' }
      );

      // Create payment intent
      const paymentIntent = await stripe.paymentIntents.create({
        amount: 999,
        currency: 'usd',
        customer: customer.id,
        automatic_payment_methods: {
          enabled: true,
        },
      });

      res.json({
        paymentIntent: paymentIntent.client_secret,
        ephemeralKey: ephemeralKey.secret,
        customer: customer.id,
      });
    } catch (error) {
      console.error('Error creating payment sheet:', error);
      res.status(500).json({ error: error.message });
    }
  });
});

exports.handleWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;

  try {
    event = stripe.webhooks.constructEvent(
      req.rawBody,
      sig,
      functions.config().stripe.webhook_secret // Configure via firebase functions:config:set
    );
  } catch (err) {
    console.error('Webhook error:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle successful payment
  if (event.type === 'payment_intent.succeeded') {
    const paymentIntent = event.data.object;
    const customerId = paymentIntent.customer;

    // Get customer email from Stripe
    const customer = await stripe.customers.retrieve(customerId);
    const email = customer.email;

    // Update user premium status in Firestore
    await admin.firestore().collection('users').where('email', '==', email).get().then((snapshot) => {
      snapshot.docs.forEach((doc) => {
        doc.ref.update({
          isPremium: true,
          premiumSince: admin.firestore.FieldValue.serverTimestamp(),
          apiCalls: 500,
        });
      });
    });
  }

  res.json({ received: true });
});
