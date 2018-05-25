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

  # https://unicode.org/emoji/charts/full-emoji-list.html
  # https://unicode.org/Public/emoji/11.0/emoji-variation-sequences.txt
  # 上記2つのページを元に正規表現を構築
  # （twemoji.jsのものとは異なるが、存在する画像にはヒットする）
  @@re = %r!((?:[\u00a9\u00ae\u23eb\u23ec\u23f0\u26ce\u2705\u270a\u270b\u2728\u274c\u274e\u2754\u2755\u2795-\u2797\u27b0\u27bf\ue50a\u{1f0cf}\u{1f18e}\u{1f191}-\u{1f19a}\u{1f201}-\u{1f236}\u{1f238}-\u{1f23a}\u{1f250}\u{1f251}\u{1f300}-\u{1f30c}\u{1f310}-\u{1f314}\u{1f316}-\u{1f31b}\u{1f31d}-\u{1f320}\u{1f32d}-\u{1f335}\u{1f337}-\u{1f377}\u{1f379}-\u{1f37c}\u{1f37e}-\u{1f392}\u{1f3a0}-\u{1f3a6}\u{1f3a8}-\u{1f3ab}\u{1f3af}-\u{1f3c1}\u{1f3c5}\u{1f3c7}-\u{1f3c9}\u{1f3cf}-\u{1f3d3}\u{1f3e1}-\u{1f3ec}\u{1f3ee}-\u{1f3f0}\u{1f3f8}-\u{1f3fa}\u{1f400}-\u{1f407}\u{1f409}-\u{1f414}\u{1f416}-\u{1f41e}\u{1f420}-\u{1f425}\u{1f427}-\u{1f43e}\u{1f440}\u{1f443}-\u{1f445}\u{1f44a}-\u{1f44c}\u{1f44f}-\u{1f452}\u{1f454}-\u{1f467}\u{1f46b}-\u{1f46d}\u{1f470}\u{1f472}\u{1f474}-\u{1f476}\u{1f478}-\u{1f47c}\u{1f47e}-\u{1f480}\u{1f483}-\u{1f485}\u{1f488}-\u{1f4a2}\u{1f4a4}-\u{1f4af}\u{1f4b1}\u{1f4b2}\u{1f4b4}-\u{1f4ba}\u{1f4bc}-\u{1f4be}\u{1f4c0}-\u{1f4ca}\u{1f4cc}-\u{1f4d9}\u{1f4db}-\u{1f4de}\u{1f4e0}-\u{1f4e3}\u{1f4e7}-\u{1f4e9}\u{1f4ee}-\u{1f4f6}\u{1f4f8}\u{1f4fc}\u{1f4ff}-\u{1f507}\u{1f509}-\u{1f50c}\u{1f50e}-\u{1f511}\u{1f514}-\u{1f53d}\u{1f54b}-\u{1f54e}\u{1f57a}\u{1f595}\u{1f596}\u{1f5a4}\u{1f5fb}-\u{1f60f}\u{1f611}-\u{1f644}\u{1f648}-\u{1f64a}\u{1f64c}\u{1f64f}\u{1f680}-\u{1f686}\u{1f688}-\u{1f68c}\u{1f68e}-\u{1f690}\u{1f692}\u{1f693}\u{1f695}-\u{1f697}\u{1f699}-\u{1f6a2}\u{1f6a4}-\u{1f6ac}\u{1f6ae}-\u{1f6b1}\u{1f6b3}\u{1f6b7}\u{1f6b8}\u{1f6bb}\u{1f6bd}-\u{1f6c5}\u{1f6cc}\u{1f6d0}-\u{1f6d2}\u{1f6eb}\u{1f6ec}\u{1f6f4}-\u{1f6f8}\u{1f910}-\u{1f925}\u{1f927}-\u{1f936}\u{1f93a}\u{1f940}-\u{1f945}\u{1f947}-\u{1f94c}\u{1f950}-\u{1f96b}\u{1f980}-\u{1f997}\u{1f9c0}\u{1f9d0}-\u{1f9d5}\u{1f9e0}-\u{1f9e6}]|[\u0023\u002a\u0030-\u0039]\ufe0f|[\u0023\u0030-\u0039]\u20e3|\u26f9\ufe0f\u200d[\u2640\u2642]\ufe0f|\u{1f1e6}[\u{1f1e8}-\u{1f1ec}\u{1f1ee}\u{1f1f1}\u{1f1f2}\u{1f1f4}\u{1f1f6}-\u{1f1fa}\u{1f1fc}\u{1f1fd}\u{1f1ff}]|\u{1f1e7}[\u{1f1e6}\u{1f1e7}\u{1f1e9}-\u{1f1ef}\u{1f1f1}-\u{1f1f4}\u{1f1f6}-\u{1f1f9}\u{1f1fb}\u{1f1fc}\u{1f1fe}\u{1f1ff}]|\u{1f1e8}[\u{1f1e6}\u{1f1e8}\u{1f1e9}\u{1f1eb}-\u{1f1ee}\u{1f1f0}-\u{1f1f5}\u{1f1f7}\u{1f1fa}-\u{1f1ff}]|\u{1f1e9}[\u{1f1ea}\u{1f1ec}\u{1f1ef}\u{1f1f0}\u{1f1f2}\u{1f1f4}\u{1f1ff}]|\u{1f1ea}[\u{1f1e6}\u{1f1e8}\u{1f1ea}\u{1f1ec}\u{1f1ed}\u{1f1f7}-\u{1f1fa}]|\u{1f1eb}[\u{1f1ee}\u{1f1ef}\u{1f1f0}\u{1f1f2}\u{1f1f4}\u{1f1f7}]|\u{1f1ec}[\u{1f1e6}\u{1f1e7}\u{1f1e9}\u{1f1ea}-\u{1f1ee}\u{1f1f1}-\u{1f1f3}\u{1f1f5}-\u{1f1fa}\u{1f1fc}\u{1f1fe}]|\u{1f1ed}[\u{1f1f0}\u{1f1f2}\u{1f1f3}\u{1f1f7}\u{1f1f9}\u{1f1fa}]|\u{1f1ee}[\u{1f1e8}-\u{1f1ea}\u{1f1f1}-\u{1f1f4}\u{1f1f6}-\u{1f1f9}]|\u{1f1ef}[\u{1f1ea}\u{1f1f2}\u{1f1f4}\u{1f1f5}]|\u{1f1f0}[\u{1f1ea}\u{1f1ec}-\u{1f1ee}\u{1f1f2}\u{1f1f3}\u{1f1f5}\u{1f1f7}\u{1f1fc}\u{1f1fe}\u{1f1ff}]|\u{1f1f1}[\u{1f1e6}-\u{1f1e8}\u{1f1ee}\u{1f1f0}\u{1f1f7}-\u{1f1fb}\u{1f1fe}]|\u{1f1f2}[\u{1f1e6}\u{1f1e8}-\u{1f1ed}\u{1f1f0}-\u{1f1ff}]|\u{1f1f3}[\u{1f1e6}\u{1f1e8}\u{1f1ea}-\u{1f1ec}\u{1f1ee}\u{1f1f1}\u{1f1f4}\u{1f1f5}\u{1f1f7}\u{1f1fa}\u{1f1ff}]|\u{1f1f4}\u{1f1f2}|\u{1f1f5}[\u{1f1e6}\u{1f1ea}-\u{1f1ed}\u{1f1f0}-\u{1f1f3}\u{1f1f7}-\u{1f1f9}\u{1f1fc}\u{1f1fe}]|\u{1f1f6}\u{1f1e6}|\u{1f1f7}[\u{1f1ea}\u{1f1f4}\u{1f1f8}\u{1f1fa}\u{1f1fc}]|\u{1f1f8}[\u{1f1e6}-\u{1f1ea}\u{1f1ec}-\u{1f1f4}\u{1f1f7}-\u{1f1f9}\u{1f1fb}\u{1f1fd}-\u{1f1ff}]|\u{1f1f9}[\u{1f1e6}\u{1f1e8}\u{1f1e9}\u{1f1eb}-\u{1f1ed}\u{1f1ef}-\u{1f1f4}\u{1f1f7}\u{1f1f9}\u{1f1fb}\u{1f1fc}\u{1f1ff}]|\u{1f1fa}[\u{1f1e6}\u{1f1ec}\u{1f1f2}\u{1f1f3}\u{1f1f8}\u{1f1fe}\u{1f1ff}]|\u{1f1fb}[\u{1f1e6}\u{1f1e8}\u{1f1ea}\u{1f1ec}\u{1f1ee}\u{1f1f3}\u{1f1fa}]|\u{1f1fc}[\u{1f1eb}\u{1f1f8}]|\u{1f1fd}\u{1f1f0}|\u{1f1fe}[\u{1f1ea}\u{1f1f9}]|\u{1f1ff}[\u{1f1e6}\u{1f1f2}\u{1f1fc}]|\u{1f3c3}(?:\u200d[\u2640\u2642]\ufe0f)?|\u{1f3c4}\u200d[\u2640\u2642]\ufe0f|\u{1f3ca}\u200d[\u2640\u2642]\ufe0f|\u{1f3cb}\ufe0f\u200d[\u2640\u2642]\ufe0f|\u{1f3cc}\ufe0f\u200d[\u2640\u2642]\ufe0f|\u{1f3f3}\ufe0f\u200d\u{1f308}|\u{1f3f4}(?:\u200d\u2620\ufe0f|\u{e0067}\u{e0062}(?:\u{e0065}\u{e006e}\u{e0067}|\u{e0073}\u{e0063}\u{e0074}|\u{e0077}\u{e006c}\u{e0073})\u{e007f})?|\u{1f468}(?:\u200d(?:[\u{1f33e}\u{1f373}\u{1f393}\u{1f3a4}\u{1f3a8}\u{1f3eb}\u{1f3ed}\u{1f466}\u{1f467}\u{1f4bb}\u{1f4bc}\u{1f527}\u{1f52c}\u{1f680}\u{1f692}]|\u{1f466}\u200d\u{1f466}|\u{1f467}\u200d[\u{1f466}\u{1f467}]|\u{1f468}\u200d\u{1f466}(?:\u200d\u{1f466})?|\u{1f467}(?:\u200d[\u{1f466}\u{1f467}])?|\u{1f469}\u200d(?:\u{1f466}(?:\u200d\u{1f466})?|\u{1f467}(?:\u200d[\u{1f466}\u{1f467}])?)|[\u2695\u2696\u2708]\ufe0f|\u2764\ufe0f\u200d(?:\u{1f468}|\u{1f48b}\u200d\u{1f468})))?|\u{1f469}(?:\u200d(?:[\u{1f33e}\u{1f373}\u{1f393}\u{1f3a4}\u{1f3a8}\u{1f3eb}\u{1f3ed}\u{1f466}\u{1f467}\u{1f4bb}\u{1f4bc}\u{1f527}\u{1f52c}\u{1f680}\u{1f692}]|\u{1f466}\u200d\u{1f466}|\u{1f467}\u200d[\u{1f466}\u{1f467}]|\u{1f469}\u200d\u{1f466}(?:\u200d\u{1f466})?|\u{1f469}\u200d\u{1f467}(?:\u200d[\u{1f466}\u{1f467}])?|[\u2695\u2696\u2708]\ufe0f|\u2764\ufe0f\u200d(?:[\u{1f468}\u{1f469}]|\u{1f48b}\u200d[\u{1f468}\u{1f469}])))?|[\u{1f46e}\u{1f46f}\u{1f471}\u{1f473}\u{1f477}\u{1f481}\u{1f482}\u{1f486}\u{1f487}\u{1f645}\u{1f646}\u{1f647}\u{1f64b}\u{1f64d}\u{1f64e}\u{1f6a3}\u{1f6b4}\u{1f6b5}\u{1f6b6}\u{1f926}\u{1f937}\u{1f938}\u{1f939}\u{1f93c}\u{1f93d}\u{1f93e}\u{1f9d6}\u{1f9d7}\u{1f9d8}\u{1f9d9}\u{1f9da}\u{1f9db}\u{1f9dc}\u{1f9dd}\u{1f9de}\u{1f9df}](?:\u200d[\u2640\u2642]\ufe0f)?|\u{1f575}(?:\ufe0f\u200d[\u2640\u2642]\ufe0f)?)|[\u203c\u2049\u2122\u2139\u2194-\u2199\u21a9\u21aa\u231a\u231b\u2328\u23cf\u23e9\u23ea\u23ed-\u23ef\u23f1-\u23f3\u23f8-\u23fa\u24c2\u25aa\u25ab\u25b6\u25c0\u25fb-\u25fe\u2600-\u2604\u260e\u2611\u2614\u2615\u2618\u261d\u2620\u2622\u2623\u2626\u262a\u262e\u262f\u2638-\u263a\u2640\u2642\u2648\u2649\u264a-\u2653\u2660\u2663\u2665\u2666\u2668\u267b\u267f\u2692-\u2697\u2699\u269b\u269c\u26a0\u26a1\u26aa\u26ab\u26b0\u26b1\u26bd\u26be\u26c4\u26c5\u26c8\u26cf\u26d1\u26d3\u26d4\u26e9\u26ea\u26f0-\u26f5\u26f7-\u26fa\u26fd\u2702\u2708\u2709\u270c\u270d\u270f\u2712\u2714\u2716\u271d\u2721\u2733\u2734\u2744\u2747\u2753\u2757\u2763\u2764\u27a1\u2934\u2935\u2b05-\u2b07\u2b1b\u2b1c\u2b50\u2b55\u3030\u303d\u3297\u3299\u{1f004}\u{1f170}\u{1f171}\u{1f17e}\u{1f17f}\u{1f202}\u{1f21a}\u{1f22f}\u{1f237}\u{1f30d}-\u{1f30f}\u{1f315}\u{1f31c}\u{1f321}\u{1f324}-\u{1f32c}\u{1f336}\u{1f378}\u{1f37d}\u{1f393}\u{1f396}\u{1f397}\u{1f399}-\u{1f39b}\u{1f39e}\u{1f39f}\u{1f3a7}\u{1f3ac}-\u{1f3ae}\u{1f3c2}\u{1f3c4}\u{1f3c6}\u{1f3ca}-\u{1f3ce}\u{1f3d4}-\u{1f3e0}\u{1f3ed}\u{1f3f3}\u{1f3f5}\u{1f3f7}\u{1f408}\u{1f415}\u{1f41f}\u{1f426}\u{1f43f}\u{1f441}\u{1f442}\u{1f446}-\u{1f449}\u{1f44d}\u{1f44e}\u{1f453}\u{1f46a}\u{1f47d}\u{1f4a3}\u{1f4b0}\u{1f4b3}\u{1f4bb}\u{1f4bf}\u{1f4cb}\u{1f4da}\u{1f4df}\u{1f4e4}-\u{1f4e6}\u{1f4ea}-\u{1f4ed}\u{1f4f7}\u{1f4f9}-\u{1f4fb}\u{1f4fd}\u{1f508}\u{1f50d}\u{1f512}\u{1f513}\u{1f549}\u{1f54a}\u{1f550}-\u{1f567}\u{1f56f}\u{1f570}\u{1f573}-\u{1f579}\u{1f587}\u{1f58a}-\u{1f58d}\u{1f590}\u{1f5a5}\u{1f5a8}\u{1f5b1}\u{1f5b2}\u{1f5bc}\u{1f5c2}-\u{1f5c4}\u{1f5d1}-\u{1f5d3}\u{1f5dc}-\u{1f5de}\u{1f5e1}\u{1f5e3}\u{1f5e8}\u{1f5ef}\u{1f5f3}\u{1f5fa}\u{1f610}\u{1f687}\u{1f68d}\u{1f691}\u{1f694}\u{1f698}\u{1f6ad}\u{1f6b2}\u{1f6b9}\u{1f6ba}\u{1f6bc}\u{1f6cb}\u{1f6cd}-\u{1f6cf}\u{1f6e0}-\u{1f6e5}\u{1f6e9}\u{1f6f0}\u{1f6f3}]([\ufe0e\ufe0f]?))!

  @@base_url = 'https://twemoji.maxcdn.com/2/72x72/'
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
    icon.codepoints.map{|c| c.to_s(16).downcase }.join('-')
  end
end


Plugin.create(:twemoji) do
  filter_score_filter do |model, note, yielder|
    if model != note
      score = Plugin::Twemoji.parse(note.description)
      if score.size > 1 || score.size == 1 && !score[0].is_a?(Plugin::Score::TextNote)
        yielder << score
      end
    end
    [model, note, yielder]
  end
end
