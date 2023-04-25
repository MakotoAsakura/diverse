# frozen_string_literal: true

module Base
  module RegexConstant
    NUMBER_HALF_WIDTH_REGEXP = /^[0-9]+$/
    KANA_REGEXP = /^([ァ-ン]|ー| |　)+$/
    URL_REGEXP = %r{^(http|https)://|[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(/.*)?$}ix
  end
end
