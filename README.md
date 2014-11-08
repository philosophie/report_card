# Report Card

Write your domain-specific reporting code and let Report Card take care of the
rest. Report Card allows your user to generate CSVs from a list of available
reports. CSVs are generated in the background, uploaded to your store via
CarrierWave, and emailed to the requester when ready.

## Requirements

* Rails
* CarrierWave
* Sidekiq

## Usage

```ruby
# app/reports/purchase_performance_report.rb
class PurchasePerformanceReport < ReportCard::Report
  def to_csv(csv)
    csv << %w[
      name
      email
      quantity_purchased
      order_total
    ]

    Order.find_each do |order|
      csv << [
        order.name,
        order.email,
        order.line_items.count,
        order.total.to_f
      ]
    end
  end
end
```

With reports defined in `app/reports`, you can navigate to
`/report_cards/reports` in your browser to begin generating reports.

```erb
# in your view
<%= link_to 'Reports', report_card_reports_path %>
```

## Configuration

```ruby
# config/initializers/report_card.rb
ReportCard.parent_controller = 'Admin::BaseController'
ReportCard.recipient_email = proc { current_admin.email }
```
