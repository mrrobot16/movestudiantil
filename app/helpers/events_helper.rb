module EventsHelper
  @@dayToES = {
    "mon":'Lunes',
    "tue":'Martes',
    "wen":"Miercoles",
    "thu":"Jueves",
    'fri':"Viernes",
    "sat":"Sabado",
    "sun":"Domingo"
  }

  @@monthToES2 ={
    "jan":"enero",
    "feb":"febrero",
    "mar":"marzo",
    "apr":"april",
    "may":"mayo",
    "jun":"junio",
    "jul":"julio",
    "aug":"agosto",
    "sep":"septiembre",
    "oct":"octubre",
    "nov":"noviembre",
    "dec":"diciembre"
  }

  def day_to_es(date)
    date = date.to_s.split(" ")
    return "#{@@dayToES[date[0].chomp(",").downcase.intern]} #{date[2].chomp(',')} de #{@@monthToES2[date[1].downcase.intern].capitalize}"
  end
end
