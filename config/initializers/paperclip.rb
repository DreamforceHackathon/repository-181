Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:style/:hash.:extension'
Paperclip::Attachment.default_options[:hash_secret] = Rails.application.secrets[:secret_key_base]
Paperclip::Attachment.default_options[:s3_protocol] = :http
Paperclip::Attachment.default_options[:s3_bucket] = ENV['S3_BUCKET_NAME']
Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_credentials] = {
    bucket: ENV['S3_BUCKET_NAME'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
}
