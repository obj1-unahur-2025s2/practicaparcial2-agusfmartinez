class Personaje {
  const fuerza
  const inteligencia
  var rol

  method fuerza() = fuerza
  method inteligencia() = inteligencia

  method nuevoRol(unRol) {
    rol = unRol
  }

  method potencialOfensivo() {
    return fuerza * 10 + rol.potencialExtra()
  }

  method esGroso() {
    return self.esInteligente() || rol.esGroso(self)
  }

  method esInteligente()

}

class Orco inherits Personaje{

  override method potencialOfensivo() {
    return super() + rol.brutalidadInnata(super())
  }

  override method esInteligente() = false
}

class Humano inherits Personaje{
  
  override method esInteligente() = inteligencia > 50
}



object guerrero {

  method potencialExtra() = 100
  method brutalidadInnata(unValor) = 0

  method esGroso(personaje) = personaje.fuerza() > 50
  
}

class Cazador{
  var mascota = new Mascota(fuerza=0, edad=0, garras=false)

  method domarMascota(unaMascota) {
    mascota = unaMascota
  }

  method potencialExtra() = mascota.potencialOfensivo()

  method brutalidadInnata(unValor) = 0

  method esGroso(personaje) = mascota.esLongeva()
}

object brujo{
  method potencialExtra() = 0

  method brutalidadInnata(unValor) = unValor * 0.1

   method esGroso(personaje) = true
}

class Mascota {
  const fuerza
  const edad
  const garras

  method initialize() {
    if(fuerza > 100){
      self.error("la fuerza no puede ser mayor a 100")
    }
  }

  method potencialOfensivo() = if(garras) fuerza * 2 else fuerza

  method esLongeva() = edad > 10
}

class Localidad {

  var ejercito = new Ejercito()

  method enlistar(unPersonaje) {
    ejercito.agregar(unPersonaje)
  }

  method poderDefensivo() = ejercito.potencial()

  method serOcupada(unEjercito) 


}

class Aldea inherits Localidad{

  const cantMaxima

  override method enlistar(unPersonaje) {
    if (ejercito.tamaño() >= cantMaxima) {
      self.error("No se pueden enlistar al ejercito")
    }
    super(unPersonaje)
  }

  override method serOcupada(unEjercito) {
    ejercito.clear()
    unEjercito.personajesOrdenadosPorPoder().forEach({p => self.enlistar(p)})
    unEjercito.quitarLosMasFuertes(cantMaxima.min(10))
  }


}

class Ciudad inherits Localidad{
  override method poderDefensivo(){
    return super() + 300
  }

  override method serOcupada(unEjercito) {
    ejercito = unEjercito
  }
}

class Ejercito {
  const property personajes = #{}

  method tamaño() {
    return personajes.size()
  }

  method potencial() {
    return personajes.sum({p => p.potencialOfensivo()})
  }

  method agregar(unPersonaje) {
    personajes.add(unPersonaje)
  }

  method puedeInvadir(unaLocalidad) {
    return self.potencial() > unaLocalidad.poderDefensivo()
  }

  method invadir(unaLocalidad){
    if(self.puedeInvadir(unaLocalidad)){
      unaLocalidad.serOcupada(self)
    }
  }

  method personajesOrdenadosPorPoder() {
    return personajes.asList().sortBy({p1,p2 => p1.potencialOfensivo() > p2.potencialOfensivo()})
  }

  method los10MasPoderosos() = self.personajesOrdenadosPorPoder().take(10)

  method quitarLosMasFuertes(cantAQuitar) {
    personajes.removeAll(self.los10MasPoderosos().take(cantAQuitar))
  }
}