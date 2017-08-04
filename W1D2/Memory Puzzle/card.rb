class Card
  attr_accessor :face_value, :face_up , :paired

  def initialize(face_value = nil)
    @face_value = face_value
    @face_up = false #false is down and true is up
    @paired = false
  end

  def hide
    if @face_up == true
      @face_up = false
    else
      nil
    end
  end

  def reveal
    if @face_up == false
      @face_up = true
    else
      nil
    end
  end

  def ==(card)
    @face_value == card.face_value
  end

  def set_paired
    @paired = true
  end


end
