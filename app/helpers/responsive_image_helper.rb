module ResponsiveImageHelper
    # record_or_attachment: モデル(@incense_review) か ActiveStorageのattachment(@incense_review.photo)
    # attachment_name: モデルを渡した時の添付名
    def responsive_image(record_or_attachment,
                         alt: "",
                         attachment_name: :photo,
                         fallback_url: nil,
                         widths: [320, 640, 960, 1280],
                         sizes: "100vw",
                         class_name: "img-fluid",
                         format: :webp,
                         quality: 70,
                         loading: "lazy",
                         decoding: "async",
                         **attrs)
  
      attachment =
        if record_or_attachment.respond_to?(attachment_name)
          record_or_attachment.public_send(attachment_name)
        else
          record_or_attachment
        end
  
      if attachment.respond_to?(:attached?) && attachment.attached?
        # vips 用：saver: {quality: ...} を使う
        make_variant = ->(w) {
          attachment.variant(
            resize_to_limit: [w, w],
            format: format,
            saver: { quality: quality, strip: true } # メタデータ削除で軽量化
          )
        }
  
        srcset_entries = widths.map { |w| "#{url_for(make_variant.call(w))} #{w}w" }
        default_w = widths[widths.length / 2]
  
        image_tag(
          url_for(make_variant.call(default_w)),
          {
            alt: alt,
            srcset: srcset_entries.join(", "),
            sizes: sizes,
            loading: loading,
            decoding: decoding,
            class: class_name
          }.merge(attrs)
        )
      elsif fallback_url.present?
        image_tag(
          fallback_url,
          {
            alt: alt,
            loading: loading,
            decoding: decoding,
            class: class_name
          }.merge(attrs)
        )
      else
        # 画像が無いときのプレースホルダ（アスペクト比は親で確保）
        content_tag(:div, "", class: "bg-light border rounded #{class_name}")
      end
    end
  end
  