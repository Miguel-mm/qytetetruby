#encoding :utf-8

module ModeloQytetet
  
  class Calle < Casilla
    
    def initialize(n, c, t, tp)
      super(n,c,t)
      @num_hoteles = 0
      @num_casas = 0
      @titulo = tp
      @titulo.casilla = self
    end
    
    #Modificador de la propiedad:
    def titulo_propiedad(ntp)
      @titulo = ntp
    end
    
    #to_s: muestra el contenido de la casilla en pantalla:
    def to_s
      str ="Número: #{@numero_casilla}. \n"
      if @tipo == :Calle
        str = str + "Tipo: #{@tipo}. \n Coste: #{@coste}. \n Propiedad de #{@titulo}. \n Número de hoteles: #{@num_hoteles}." + 
        "\n Número de casas: #{@num_casas}."
      
      else
        str = str +"Tipo: #{@tipo}. \n Coste: #{@coste}. \n"
      end
      
      return str
    end
    
    def asignar_propietario(jugador)
      
      @titulo.propietario = jugador
    end
    
    def calcular_valor_hipoteca
      
      hipo = @titulo.hipoteca_base
      
      hipo = hipo + ((@num_casas * 0.5 * hipo)
                       + (@num_hoteles * hipo)).to_i
    end
    
    def cancelar_hipoteca
      valor_hipoteca = calcular_valor_hipoteca
      porcentaje = valor_hipoteca * 0.1
      valor_hipoteca = (valor_hipoteca + porcentaje).to_i
      
      valor_hipoteca
    end
    
    def cobrar_alquiler
      coste_alquiler = (titulo.alquiler_base + (@num_casas * 0.5) + (@num_hoteles * 2)).to_i
      @titulo.propietario.modificar_saldo(coste_alquiler)
      
      coste_alquiler
      
    end
    
    def edificar_casa
      @num_casas = @num_casas + 1
    end
    
    def edificar_hotel
      @num_hoteles = @num_hoteles + 1
    end

    def esta_hipotecada
      return @titulo.hipotecada 
    end
    
    def hipotecar

      @titulo.hipotecada = true;
      valor_hipoteca = calcular_valor_hipoteca
                     
      return valor_hipoteca
    end
    
    #Suma de coste, suma de precio casa y hoteles * lo que cuesta edificar
    def precio_total_comprar
      precio_compra = @coste + ((@num_casas + @num_hoteles) * @titulo.precio_edificar).to_i
      
      return precio_compra
    end
    
    def propietario_encarcelado 
      raise "No implementado"
    end
    
    def se_puede_edificar_casa(factor_especulador)
     
      resultado = false
      
      if(@num_casas < 4 * factor_especulador)
        resultado = true
      end
      
      resultado
    end
    
    def se_puede_edificar_hotel(factor_especulador)
        resultado = false
      
      if(@num_casas == 4 * factor_especulador && @num_hoteles < 4 * factor_especulador)
        resultado = true
        
      end
      
      resultado
    end

    def tengo_propietario
      
      resultado = false
      
      if(!@titulo.nil? && @titulo.tengo_propietario())
        resultado = true
      end
      
      resultado
    end
    
    def vender_titulo
      
      precio_compra = precio_total_comprar
      precio_venta = (precio_compra + @titulo.factor_revalorizacion*precio_compra).to_i
      @titulo.propietario = nil
      
      @hoteles = 0
      @casas = 0
      
      precio_venta
    end

  end
end
