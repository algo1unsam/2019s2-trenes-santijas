class Deposito{
	const property formaciones = []
	const property locomotorasSueltas = []
	
	method vagonesMasPesados(){
		//const lista = []
		//lista.add( formaciones.all({ formacion => formacion.vagones().max({ vagon => vagon.pesoMaximo()}) }))
		//return lista 
		
		return formaciones.map({ formacion => formacion.vagones().max({vagon => vagon.pesoMaximo()} )})
	
	}
	
	method conductorExperimentado(){
		return self.formacionComplejaPorUnidad() or self.formacionComplejaPorPeso()

	}
	
	method formacionComplejaPorUnidad(){
		return formaciones.any({ formacion => (formacion.vagones().size()+ formacion.locomotoras().size()) >20 })
	}
	
	method formacionComplejaPorPeso(){
		return true // VER LUEGO
	}
	
	method agregaLocomotora(formacion){
		if (not(formacion.puedeMoverse())){
			formacion.locomotoras().add(self.locomotoraPorAgregar())
		} 
	}
	
	method locomotoraPorAgregar(){
		return formaciones.any({f => f.kilosFaltantes()< locomotorasSueltas.arrastreUtil()}).first()
			
}
}


class Formacion{
	const property vagones = []
	const property locomotoras = []
	
	method vagonesLivianos(){
		return vagones.filter({vagon => vagones.pesoMaximo()<2500})
	}
	
	method velocidadMaxima(){
		return locomotoras.min({locomotora => locomotora.velMax()}).velMax()
	}
	
	method eficiente(){
		return locomotoras.all({locomotora=> locomotora.pesoMaximoLlevado()> (locomotora.peso()*5)})
	}
	
	method puedeMoverse(){
		return locomotoras.sum({locomot => locomot.arrastreUtil()})>= vagones.sum({vagon => vagon.pesoMaximo()})
	}
	
	method kilosFaltantes(){
		if (self.puedeMoverse()){ 
			return 0
		}else {
			return vagones.sum(vagones.pesoMaximo()) - locomotoras.sum({ locomotoras.arrastreUtil()})
		}
	}
}

class Vagon{
	var property anchoUtil
	var property largo
	var property tipoVagon
	
	
	method cantidadPasajeros(){
		return tipoVagon.cantidadPasajeros(anchoUtil, largo)
	}
	
	method pesoMaximo(){
		return tipoVagon.pesoMaximo(self.cantidadPasajeros())
	}	
}

class VagonCarga{
	var property cargaMax
	
	method cantidadPasajeros(ancho, largo){ return 0}	
	
	method pesoMaximo(cantidadPasajeros){
		return cargaMax + 160
	}
	
}

object vagonPasajeros{
	
	method cantidadPasajeros(anchoUtil, largo){
		if (anchoUtil<= 2.5){
			return largo*8
		} else return largo*10
	}	
	
		method pesoMaximo(cantidadPasajeros){
			return cantidadPasajeros*80
	}	
	
	
}

class Locomotora{
	var property peso
	var property pesoMaximoLlevado
	var property velMax
	
	method arrastreUtil(){ 
		if ( (pesoMaximoLlevado - peso) >0 ){
			return pesoMaximoLlevado - peso
		}else return 0
	}
	
}