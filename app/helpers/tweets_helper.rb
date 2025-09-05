module TweetsHelper
  # 既存の星表示用
  def getPercent(number)
    if number.present?
      calPercent = number / 5.to_f * 100
      calPercent.round.to_s
    else
      0
    end
  end

  # ===== 材料を配列に整形 =====
  # 入力の例:
  # [A] 生地
  # 薄力粉 100g
  # 水400
  # ウスターソース大さじ1
  # 100 ml 牛乳
  # ニンニク1片（みじん切り）
  def parse_ingredients(text)
    return [] if text.blank?

    lines = text.to_s.gsub("\r\n", "\n").split("\n")
    blocks = []
    current = { title: nil, items: [] }

    section_re = /\A\[(.+?)\]\s*(.+)?\z/

    lines.each do |raw|
      line = raw.strip
      next if line.blank?

      # セクション見出し
      if (m = line.match(section_re))
        blocks << current if current[:items].present?
        current = { title: [m[1], m[2]].compact.join(" ").strip, items: [] }
        next
      end

      # 先頭の記号/番号を除去
      line = line.sub(/\A(\-|・|\*|\d+\)|\d+\.)\s*/, "")

      # 全角→半角（数字・小数点・スラッシュ）
      line = line.tr("０-９．／", "0-9./")

      # ① 数量が先: "100 g 砂糖" / "50ml 牛乳"
      qty_first_re = /
        \A
        (?<qty>\d+(?:\.\d+)?|適量|少々)
        \s*(?<unit>g|kg|ml|mL|l|L|cc|大さじ|小さじ|本|個|枚|片)?
        \s+(?<name>.+?)
        (?:\s*[\(（](?<note>[^)）]+)[\)）])?
        \z
      /x

      # ② 名前が先（スペースあり）: "砂糖 100 g（常温）"
      name_space_re = /
        \A
        (?<name>.+?)
        (?:\s+(?<qty>\d+(?:\.\d+)?|適量|少々))?
        \s*(?<unit>g|kg|ml|mL|l|L|cc|大さじ|小さじ|本|個|枚|片)?
        (?:\s*[\(（](?<note>[^)）]+)[\)）])?
        \z
      /x

      # ③ 名前＋数量が連結（スペースなし）: "ごはん400" / "ニンニク1片" / "カレールー80g"
      name_nospace_tail_re = /
        \A
        (?<name>.+?)
        (?<qty>\d+(?:\.\d+)?(?:\/\d+)?)
        \s*(?<unit>g|kg|ml|mL|l|L|cc|大さじ|小さじ|本|個|枚|片)?
        (?:\s*[\(（](?<note>[^)）]+)[\)）])?
        \z
      /x

      m = line.match(qty_first_re) || line.match(name_space_re) || line.match(name_nospace_tail_re)

      item =
        if m
          {
            name: m[:name].to_s.strip,
            qty:  m[:qty].to_s.strip.presence,
            unit: m[:unit].to_s.strip.presence,
            note: m[:note].to_s.strip.presence
          }
        else
          { name: line, qty: nil, unit: nil, note: nil }
        end

      current[:items] << item
    end

    blocks << current if current[:items].present?
    blocks.presence || []
  end

  # ===== 作り方を配列に分割 =====
  def parse_steps(text)
    return [] if text.blank?

    body = text.to_s.gsub("\r\n", "\n").strip
    parts = body.split(/\n{2,}|(?:\A|\n)\s*(?:\d+[\.\)]|\-|\・)\s*/).map(&:strip)
    if parts.size <= 1
      parts = body.split(/\n/).map { |l| l.sub(/\A(\d+[\.\)]|\-|\・)\s*/, "").strip }
    end
    parts.reject(&:blank?)
  end
end
