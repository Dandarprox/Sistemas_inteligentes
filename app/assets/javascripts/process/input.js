$(function(){
    $("#guardar").click(function(){
        var gustos = "";
        if( $('input#g1').is(':checked'))
            gustos += "Cine, ";
        if( $('input#g2').is(':checked'))
            gustos += "Literatura, ";
        if( $('input#g3').is(':checked'))
            gustos += "Musica, ";
        if( $('input#g4').is(':checked'))
            gustos += "Deportes, ";
        if( $('input#g5').is(':checked'))
            gustos += "Arte, ";
        if( $('input#g6').is(':checked'))
            gustos += "Tecnologia, ";
        if( $('input#g7').is(':checked'))
            gustos += "Ciencias exactas, ";
        if( $('input#g8').is(':checked'))
            gustos += "Gastronomia, ";
        if( $('input#g9').is(':checked'))
            gustos += "Manualidades ,";
        if( $('input#g10').is(':checked'))
            gustos += "Ciencias sociales y humanas, ";

        gustos = gustos.substring(0, gustos.length - 2);
        gustos += "";

        $("#user_liking").val(gustos);

         Materialize.toast('Gustos guardados', 2500, 'rounded green darken-4')
    });


    $("#guardar2").click(function(){
        var ocupacion = "";
        if( $('input#o1').is(':checked'))
            ocupacion += "Estudiante, ";
        if( $('input#o2').is(':checked'))
            ocupacion += "Trabajador, ";
        if( $('input#o3').is(':checked'))
            ocupacion += "Sin ocupacion, ";


        ocupacion = ocupacion.substring(0, ocupacion.length - 2);
        ocupacion += "";

        $("#user_ocupation").val(ocupacion);

         Materialize.toast('Ocupacion guardada', 2500, 'rounded light-green darken-4')
    });


})
