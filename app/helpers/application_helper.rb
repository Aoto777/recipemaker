# app/helpers/application_helper.rb
module ApplicationHelper
  # 材料テキストを [ {title:, items:[{name:, qty:, unit:, note:}]} ] に変換
  def parse_ingredients(text)
    blocks = [{ title: nil, items: [] }]

    text.to_s.lines.each do |raw|
      line = raw.strip
      next if line.blank?

      # [A] や 【たれ】 のような小見出しを検出
      if (line.start_with?('[') && line.end_with?(']')) ||
         (line.start_with?('【') && line.end_with?('】'))
        title = line.tr('[]【】', '')
        blocks << { title: title, items: [] }
        next
      end

      # 「食材…分量」/「食材: 分量」/「食材　分量」などにゆるく対応
      name, rest =
        if line.include?('…')
          line.split('…', 2).map(&:strip)
        elsif line.include?(':')
          line.split(':', 2).map(&:strip)
        elsif line.include?('：')
          line.split('：', 2).map(&:strip)
        else
          [line, nil]
        end

      # 量（qty+unit）の厳密分割は省略。全部 note に入れて表示に回す
      blocks.last[:items] << { name: name, qty: nil, unit: nil, note: rest }
    end

    # 中身がないブロックは除外
    blocks.reject { |b| b[:items].empty? }
  end

  # 作り方は行ごとに配列化
  def parse_steps(text)
    text.to_s.lines.map { |l| l.strip }.reject(&:blank?)
  end
end
