CarrierWave.configure do |c|
    if Rails.env.production?
    c.cache_storage = :file  # 一時保存はローカル
    c.cache_dir  = Rails.root.join('tmp','uploads')  #  /tmp 配下に変更
    end
end