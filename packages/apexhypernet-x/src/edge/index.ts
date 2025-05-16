import Stripe from 'stripe';
import { json } from 'micro';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY, { apiVersion: '2022-11-15' });
const PRICE_ID = 'price_1RPWXhCr7KoY6lsaEEKTcS23';

export default async function handler(req, res) {
  const { customerId } = await json(req);

  const subscriptionItemId = await getOrCreateSubscriptionItem(customerId);

  await stripe.usageRecords.create({
    subscription_item: subscriptionItemId,
    quantity: 1,
    timestamp: Math.floor(Date.now() / 1000),
    action: 'increment',
  });

  const action = Math.random() < 0.5 ? 'A' : 'B';
  res.status(200).json({ action });
}

async function getOrCreateSubscriptionItem(customerId: string): Promise<string> {
  const subs = await stripe.subscriptions.list({
    customer: customerId,
    status: 'active',
    expand: ['data.items'],
    limit: 1,
  });
  if (subs.data.length) {
    return subs.data[0].items.data[0].id;
  }
  const newSub = await stripe.subscriptions.create({
    customer: customerId,
    items: [{ price: PRICE_ID }],
    expand: ['items.data'],
  });
  return newSub.items.data[0].id;
}
