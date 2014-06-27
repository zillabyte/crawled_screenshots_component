require 'zillabyte'

CRAWL_DOMAIN_ID = 666
SCREENSHOT_ID = 999

comp = Zillabyte.component "stripe_web_crawl_screenshots"

# Declare the schema for inputs to the component
input_stream = comp.inputs do
  field "domain", :string
end


# Call the 'crawl_domain' component; which will crawl the given incoming 'domain'
# every tuple found with the form ("url", "html)
crawl_stream = stream.call_component do
  component_id CRAWL_DOMAIN_ID
  name "crawl_domain"
end

# Now call the 'web_screenshot' component, which will take a screenshot
# on the incoming 'url' field and return the tuple ('url', 'html', 'image_url'),
# where the 'image_url' is a public facing URL of the screenshot
screenshot_stream = stream.call_component do
  component_id SCREENSHOT_ID
  name "web_screenshot"
end

# Output tuples
screenshot_stream.outputs
