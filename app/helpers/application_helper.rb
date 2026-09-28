module ApplicationHelper
  POWER_ICONS = {
    /fl(y|ight)|soar|wing/i => "fa-feather-pointed",
    /strength|strong|lift/i => "fa-dumbbell",
    /invisib|vanish|stealth/i => "fa-ghost",
    /tele(port|kinesis)|mind|psychic/i => "fa-brain",
    /speed|fast|sprint/i => "fa-bolt",
    /fire|flame|heat/i => "fa-fire",
    /ice|freez|frost|cold/i => "fa-snowflake",
    /x-?ray|vision|sight|see/i => "fa-eye",
    /time|pause|rewind/i => "fa-hourglass-half",
    /water|swim|breath/i => "fa-water",
    /heal/i => "fa-heart-pulse",
    /talk|animal|language/i => "fa-paw",
    /weather|storm|rain|lightning/i => "fa-cloud-bolt"
  }.freeze

  def power_icon(superpower)
    POWER_ICONS.find { |pattern, _| superpower.name.to_s.match?(pattern) }&.last || "fa-star"
  end

  # The uploaded photo if there is one, otherwise a halftone panel with an icon.
  # url_for works with Cloudinary in production and local disk in development.
  def cover_for(superpower, large: false)
    classes = ["cover", "cover--#{superpower.id.to_i % 3}", ("cover--lg" if large)].compact.join(" ")
    content_tag :div, class: classes do
      if superpower.photo.attached?
        image_tag url_for(superpower.photo), alt: superpower.name, loading: "lazy"
      else
        tag.i(class: "fa-solid #{power_icon(superpower)}", aria: { hidden: true })
      end
    end
  end

  def avatar_for(user)
    content_tag :span, user.initials, class: "avatar", aria: { label: user.display_name }, role: "img"
  end

  def money(amount)
    number_to_currency(amount, unit: "£", precision: amount.to_d.frac.zero? ? 0 : 2)
  end

  def stars(rating)
    ("★" * rating.to_i) + ("☆" * (5 - rating.to_i))
  end

  def nav_link(label, path, icon:)
    active = current_page?(path)
    link_to path, class: ("is-active" if active), aria: { current: (active ? "page" : nil) } do
      safe_join([tag.i(class: "fa-solid #{icon}", aria: { hidden: true }), " ", tag.span(label)])
    end
  end
end
