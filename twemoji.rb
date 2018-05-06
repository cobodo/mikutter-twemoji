# https://github.com/twitter/twemoji/blob/gh-pages/twemoji.js
module Plugin::Twemoji
  extend self

  class Twemoji < Diva::Model
    register :score_twemoji, name: "Twemoji"
    field.string :description, required: true
    field.uri :url, required: true

    memoize def inline_photo
      Plugin.filtering(:photo_filter, url, [])[1].first
    end

    def inspect
      "twemoji(#{description.codepoints.to_s})"
    end

    def path
      "/#{url.host}/#{url.path}"
    end
  end

  # twemojiの正規表現をruby向けに変換
  @@re = /(?:\u0023\uFE0F?\u20E3|[\u0030-\u0039]\uFE0F?\u20E3|\u{1F1E8}\u{1F1F3}|\u{1F1E9}\u{1F1EA}|\u{1F1EA}\u{1F1F8}|\u{1F1EB}\u{1F1F7}|\u{1F1EC}\u{1F1E7}|\u{1F1EE}\u{1F1F9}|\u{1F1EF}\u{1F1F5}|\u{1F1F0}\u{1F1F7}|\u{1F1F7}\u{1F1FA}|\u{1F1FA}\u{1F1F8}|[\u{1F0CF}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F1E6}-\u{1F1FF}\u{1F201}\u{1F232}-\u{1F236}\u{1F238}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F320}\u{1F330}-\u{1F335}\u{1F337}-\u{1F37C}\u{1F380}-\u{1F393}\u{1F3A0}-\u{1F3CA}\u{1F3E0}-\u{1F3F0}\u{1F400}-\u{1F43E}\u{1F440}\u{1F442}-\u{1F4FC}\u{1F500}-\u{1F53D}\u{1F550}-\u{1F567}\u{1F5FB}-\u{1F640}\u{1F645}-\u{1F6C5}\u00A9\u00AE\u23E9-\u23EC\u23F0\u23F3\u26CE\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2795-\u2797\u27B0\u27BF\uE50A])|(?:[\u{1F004}\u{1F170}\u{1F171}\u{1F17E}\u{1F17F}\u{1F202}\u{1F21A}\u{1F22F}\u{1F237}\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600\u2601\u260E\u2611\u2614\u2615\u261D\u263A\u2648-\u2653\u2660\u2663\u2665\u2666\u2668\u267B\u267F\u2693\u26A0\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2702\u2708\u2709\u270C\u270F\u2712\u2714\u2716\u2733\u2734\u2744\u2747\u2757\u2764\u27A1\u2934\u2935\u2B05\u2B06\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]([\uFE0E\uFE0F]?))/

  @@base_url = 'https://abs.twimg.com/emoji/v2/72x72/'
  @@ext = '.png'

  def genUrl(icon)
    "#{@@base_url}#{icon}#{@@ext}"
  end

  def parse(str)
    score = []
    while str.size > 0 && (m = @@re.match(str))
      icon = m[0]
      variant = m[1]
      src = genUrl(grabTheRightIcon(icon, variant))
      if src
        if m.pre_match.size > 0
          score << m.pre_match
        end
        score << Twemoji.new(description: icon, url: Diva::URI.new(src))
      else
        score << m.pre_match + m[0]
      end
      str = m.post_match
    end
    if str.size > 0
      score << str
    end

    score
      .chunk { |fragment| fragment.class }
      .flat_map do |klass, fragments|
        if klass == String
          [Plugin::Score::TextNote.new(description: fragments.join(''))]
        else
          fragments
        end
      end
  end

  def grabTheRightIcon(icon, variant)
    if variant == "\uFE0F"
      icon = icon[0...-1]
    elsif icon.size == 3 && icon[1] == "\uFE0F"
      # fix non standard OSX behavior
      icon = icon[0] + icon[2]
    end
    icon.split('').flat_map{|c| c.codepoints.map{|c| c.to_s(16).downcase } }.join('-')
  end
end


Plugin.create(:twemoji) do
  filter_score_filter do |model, note, yielder|
    score = Plugin::Twemoji.parse(note.description)
    if score.size > 1 || score.size == 1 && !score[0].is_a?(Plugin::Score::TextNote)
      yielder << score
    end
    [model, note, yielder]
  end
end
