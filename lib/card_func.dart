
class CardFunc {


  static String tempo(DateTime time, String get){

    String hora = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    String data = "${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year}";


  if(get == "hora"){
      return hora;
    }
    else if(get == "data"){
    return data;
    }
    else {
   return "";
    }


  }


}