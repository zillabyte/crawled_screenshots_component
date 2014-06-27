require 'zillabyte'

CRAWL_DOMAIN_ID = 666
SCREENSHOT_ID = 999

comp = Zillabyte.component "web_crawl_screenshots"

# Declare the schema for inputs to the component
input_stream = comp.inputs do
  field "domain", :string
end


# Call the 'crawl_domain' component; which will crawl the given incoming 'domain'
# and every tuple found with the form ("url", "html)
stream = stream.call_component do
  component_id CRAWL_DOMAIN_ID
  outputs "crawl_stream"
end

# The stream now contains HTML... save it to persistent storage... 
stream = stream.each do |tuple|
  
  url = tuple[:url]
  html = tuple[:html]
  
  # TODO: save html to s3 storage... 
  log "saving html to: #{url}"
  
  # Emit the URL back to the stream for the screenshot.. 
  emit :url => url
  
end


# Now call the 'web_screenshot' component, which will take a screenshot
# on the incoming 'url' field and return the tuple ('url', 'png_image_b64'),
# where 'png_image_b64' holds the image content bytes"
stream = stream.call_component do
  component_id SCREENSHOT_ID
  outputs "screenshot_stream"
end

# Now, save the png images
stream = stream.each do |tuple|
  
  url = tuple[:url]
  png_b64 = tuple[:png_image_b64]
  
  # TODO: Save the image to a store of your choice such as S3
  
  # Emit the url back to the stream, just so the caller knows what we've processed... 
  emit :url => url 
  
end


# Output the urls
stream.outputs do
  field :url, :string
end
