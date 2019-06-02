class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate  :validates_url_format

  private

  def validates_url_format
    errors.add(:url, 'is not a valid HTTP URL') unless url.present? && compliant?(url)
  end

  def compliant?(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
