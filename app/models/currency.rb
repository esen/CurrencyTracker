class Currency < ActiveRecord::Base
  self.primary_key = :code
  attr_accessible :name, :code, :country_id

  validates_presence_of :name
  validates_presence_of :code
  validates_uniqueness_of :code, :allow_blank => true

  belongs_to :country

  def self.all_of_user(user, filter_value)
    currencies = self.
      joins(:country).
      joins("LEFT OUTER JOIN visitations ON countries.code = visitations.country_code AND user_id = #{user.id}").
      select("currencies.*, visitations.id as collected")
    currencies = currencies.where("currencies.name LIKE ?", "%#{filter_value}%") if filter_value.length > 0
    currencies
  end

  def self.collected(user)
    self.
      joins(:country).
      joins("INNER JOIN visitations ON countries.code = visitations.country_code").
      where("visitations.user_id = #{user.id}")
  end

  def self.not_collected(user)
    self.
      joins(:country).
      joins("LEFT JOIN visitations ON countries.code = visitations.country_code AND user_id = #{user.id}").
      where("visitations.id IS NULL")
  end

  def collected?(*args)
    unless args[0].nil?
      args[0].visitations.where(:country_code => country.code).count > 0
    else 
      if self.respond_to?(:collected) 
        self.collected.to_i > 0
      end
    end
  end
end
