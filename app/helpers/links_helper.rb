module LinksHelper
  def gist?(link)
    result = link.url.match(%r{https\://gist.github.com})
    !result.nil?
  end

  def get_gist_files(link)
    res = link.url.match(%r{https\://gist.github.com/[^/]+/(?<id>[0-9a-z]+)})
    return unless res

    result = GistService.new.gist(res[:id])
    result.files
  end
end
