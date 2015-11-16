module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  
  def helper_class(field)
    params[:sort].to_s == field ? "hilite" : nil
  end
  
end
