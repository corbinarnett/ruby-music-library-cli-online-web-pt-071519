require 'pry'
class Song
  attr_accessor :name
  attr_reader :artist

  @@all = []

  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.artist = artist if artist
    self.genre = genre if genre
    # @@all << self
  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all.clear
  end

  def save
    @@all << self
  end

  def self.create(name)
    song = new(name)
    song.save
    song
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
    genre.songs << self unless genre.songs.include?(self)
  end

  def genre
    @genre
  end

  def self.find_by_name(name)
    all.detect{ |song| song.name == name }
  end


  def self.find_or_create_by_name(name)
    find_by_name(name) || self.create(name)
  end

  def self.new_from_filename(file_name)
    artist,song,genre_name = file_name.split(" - ")
    fixed_name = genre_name.gsub(".mp3", '')
    artist = Artist.find_or_create_by_name(artist)
    genre = Genre.find_or_create_by_name(fixed_name)
    new(song, artist, genre)
  end

  def self.create_from_filename(name)
    new_from_filename(name).save
  end

end