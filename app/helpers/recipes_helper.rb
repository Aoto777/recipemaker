# app/helpers/recipes_helper.rb
module RecipesHelper
  #==============================
  # Public API
  #==============================

  # 材料テキストをブロック（セクション）ごとに配列化
  # 返り値例:
  # [
  #   { title: "A 生地", items: [{name:"薄力粉", qty:"100", unit:"g", note:"ふるう"}] },
  #   { title: nil,       items: [{name:"砂糖",   qty:"20",  unit:"g"}] }
  # ]
  def parse_ingredients(text)
    return [] if text.blank?

    lines   = normalize_newlines(text).split("\n")
    blocks  = []
    current = empty_block

    lines.each do |raw|
      line = raw.strip
      next if line.empty?

      # セクション見出し: [A] 生地 / [B] 仕上げ / [1] など
      if (m = SECTION_RE.match(line))
        blocks << current if current[:items].any?
        title_left  = m[1].to_s.strip # A / 1 など
        title_right = m[2].to_s.strip # 生地 / 仕上げ など
        title = [title_left, title_right.presence].compact.join(" ").strip
        current = { title: title.presence, items: [] }
        next
      end

      # 先頭の箇条書き記号・番号を除去
      clean = strip_bullet(line)

      # 「名称 qty unit（注記）」をゆるく抽出
      item = extract_item(clean)

      current[:items] << item
    end

    blocks << current if current[:items].any?
    blocks
  end

  # 作り方テキストを番号/記号/改行で分割して配列化
  # 返り値例: ["ボウルに卵を入れる", "よく混ぜる"]
  def parse_steps(text)
    return [] if text.blank?

    body = normalize_newlines(text).strip
    return [] if body.empty?

    # まずは空行 or 箇条書きパターンで分割
    chunks = body.split(STEP_SPLIT_RE).map { |s| strip_leading_marker(s) }.map!(&:strip)
    # 単一要素しか得られない場合は、行単位で再分割
    if chunks.length <= 1
      chunks = body.split(/\n/).map { |s| strip_leading_marker(s).strip }
    end

    chunks.reject!(&:blank?)
    chunks
  end
end