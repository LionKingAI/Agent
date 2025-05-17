# Creates a Stripe Checkout Session and prints its URL

# 1) Load your secret key
$secretKey = $Env:STRIPE_SECRET_KEY

# 2) Build the session request
$body = @{
  "payment_method_types[]"                                = "card"
  "mode"                                                  = "payment"
  "line_items[][price_data][currency]"                    = "aud"
  "line_items[][price_data][unit_amount]"                 = "100"           # 100 cents = AUD $1.00
  "line_items[][price_data][product_data][name]"          = "One-Time Service"
  "line_items[][quantity]"                                = "1"
  "success_url"                                           = "https://example.com/success"
  "cancel_url"                                            = "https://example.com/cancel"
}

# 3) Call Stripe to make the session
$response = Invoke-RestMethod `
  -Method Post `
  -Uri 'https://api.stripe.com/v1/checkout/sessions' `
  -Headers @{ Authorization = "Bearer $secretKey" } `
  -Body $body

# 4) Print the URL where customers can pay
Write-Host "Checkout your customer here:" $response.url
