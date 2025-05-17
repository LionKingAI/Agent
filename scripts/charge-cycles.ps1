# This script runs every time GitHub triggers it
$secretKey = $Env:STRIPE_SECRET_KEY
$response = Invoke-RestMethod -Method Get `
  -Uri 'https://api.stripe.com/v1/charges?limit=1' `
  -Headers @{ Authorization = "Bearer $secretKey" }
$response.data | Format-List
