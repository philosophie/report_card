# Report Card [![Stories in Backlog](https://badge.waffle.io/philosophie/report_card.svg?label=ready&title=Backlog)](http://waffle.io/philosophie/report_card)

Write your domain-specific reporting code and let Report Card take care of the
rest. Report Card allows your user to generate CSVs from a list of available
reports. CSVs are generated in the background, uploaded to your store via
CarrierWave, and emailed to the requester when ready.

## Requirements

* [Rails][rails]
* [CarrierWave][carrierwave]
* [Sidekiq][sidekiq]

[rails]: https://github.com/rails/rails
[carrierwave]: https://github.com/carrierwaveuploader/carrierwave
[sidekiq]: https://github.com/mperham/sidekiq

## Quick Start

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

### Configuration

Use proc instead of string for recipient_email and flash_success in case they need to be evaluated. They will be evaluated within the controller instance.
For instance, `proc { current_admin.email }`

```ruby
# config/initializers/report_card.rb
ReportCard.parent_controller = 'Admin::BaseController'
ReportCard.recipient_email = proc { current_admin.email }
ReportCard.from_email = 'support@mysite.com'
ReportCard.subject = 'Your report is ready'
ReportCard.body = 'Download your report: '
ReportCard.flash_success = proc { 'Generating report. It will be emailed to you.' }
```

## Usage

### Reports

Report Card uses *reports*, which are simple classes that inherit from `ReportCard::Report`. To define a report, implement the `to_csv` method, which accepts a single argument, an empty CSV handle.

```ruby
class CustomReport < ReportCard::Report
  def to_csv(csv)
  end
end
```

Add rows to the `csv` argument as arrays, which will be written to a CSV using Ruby's `CSV` class.

```ruby
def to_csv(csv)
  csv << ['Name', 'Email']
  User.find_each do |user|
    csv << [user.name, user.email]
  end
end
```

The `params` hash of the request that initiated the report is also available from within a `Report`, which can be used to limit the scope of the report.

```ruby
def to_csv(csv)
  user = User.find params[:user_id]
  csv << ['ID', 'Title']
  user.posts.each do |post|
    csv << [post.id, post.title]
  end
end
```

### Generating and Sending Reports

The easiest way to create and send reports is via the automatically-generated route, `/report_card/reports`. Issuing an HTTP GET request will return an index of all the reports available for generation, and issuing a POST request will actually create and send a report.

To specify which report to send, include the name of a `Report` subclass in the params with `report_name` as the key.

```erb
<%= link_to 'Generate Report', report_card_reports_path(report_name: 'CustomReport'), method: :post %>
```

After the report is created, the user will be redirected to the previous page.

#### Manually Generating Reports

Reports can also be manually created from a custom controller by creating an instance of `ReportCard::Runner` directly, then calling `perform_async` to kick off the Sidekiq job. The recipient email set in [the Report Card defaults](#configuration) will not be automatically merged into the params hash, so it will need to be manually provided.

```ruby
ReportCard::Runner.perform_async(
  report_name: 'CustomReport',
  email_options: { recipient_email: params[:email] }
)
```

## Configuring CarrierWave

Report Card uses [CarrierWave][carrierwave] to upload and store the generated reports. It can be additionally configured to customize where the reports are saved. For example, to save all reports to Amazon S3, you would need to install the `fog` gem, then configure CarrierWave itself:

```ruby
CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     'xxx',
    aws_secret_access_key: 'yyy',
    region:                'us-west-2'
  }
  config.fog_directory  = 'name_of_directory'
  config.fog_public     = true
  config.fog_attributes = { cache_control: "max-age=#{1.year.to_i}" }
end
```

For additional information and options, see [CarrierWave's documentation][carrierwave].
