require 'zillabyte'

CRAWL_DOMAIN_ID = 666
SCREENSHOT_ID = 999

comp = Zillabyte.component "web_crawl_screenshots"

# Declare the schema for inputs to the component
input_stream = comp.inputs do
  field "domain", :string
end


# Call the 'crawl_domain' component; which will crawl the given incoming 'domain'
# every tuple found with the form ("url", "html)
stream = stream.call_component("crawl")


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
# on the incoming 'url' field and return the tuple ('url', 'html', 'image_url'),
# where the 'image_url' is a public facing URL of the screenshot
stream = stream.call_component("web_screenshot")


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
