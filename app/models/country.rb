class Country < ActiveRecord::Base
  self.primary_key = :code
  attr_accessible :name, :code, :visited

  validates_presence_of :name
  validates_presence_of :code
  validates_uniqueness_of :code, :allow_blank => true

  has_many :currencies
  has_many :visitations, :foreign_key => "country_code"

  accepts_nested_attributes_for :currencies, :allow_destroy => true

  attr_accessor :visited

  def self.all_of_user(user, filter_value)
    countries = self.
      joins("LEFT OUTER JOIN visitations ON countries.code = visitations.country_code AND user_id = #{user.id}").
      select("countries.*, visitations.id as visited_attr")
    countries = countries.where("countries.name LIKE ?", "%#{filter_value}%") if filter_value.length > 0
    countries
  end

  def self.visited(user)
    self.
      joins("INNER JOIN visitations ON countries.code = visitations.country_code").
      where("visitations.user_id = #{user.id}")
  end

  def self.not_visited(user)
    self.
      joins("LEFT JOIN visitations ON countries.code = visitations.country_code AND user_id = #{user.id}").
      where("visitations.id IS NULL")
  end

  def visited?
    self.visited || (self.visited_attr.to_i > 0 rescue false)
  end

  def assign_visited(user)
    self.visited = (user.visitations.where(:country_code => code).count > 0)
  end
end
