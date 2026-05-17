package com.washtrack.washtrack_api.util.response;

import com.washtrack.washtrack_api.util.constantes.ConstantesMensajesGenericos;
import com.washtrack.washtrack_api.util.constantes.ConstantesNumericas;
import org.springframework.stereotype.Component;

@Component
public class MapearRespuestasConsultasUtil {
  
  public <T> ServiceResult<T> mapearserviceResultError(String mensaje, T datos) {
    // Setear la respuesta por default
    ServiceResult<T> serviceResult = new ServiceResult<>(
        false,
        ConstantesMensajesGenericos.RESPUESTA_GENERICA,
        ConstantesNumericas.CERO,
        null
    );
    
    serviceResult.setSuccess(false);
    serviceResult.setMessage(mensaje);
    serviceResult.setRegistros(ConstantesNumericas.CERO);
    serviceResult.setData(datos);
    
    return serviceResult;
  }
  
  public <T> ServiceResult<T> mapearserviceResultRespuestaOk(String mensaje,
      int registros, T datos) {
    // Setear la respuesta por default
    ServiceResult<T> serviceResult = new ServiceResult<>(
        false,
        ConstantesMensajesGenericos.RESPUESTA_GENERICA,
        ConstantesNumericas.CERO,
        null
    );
    
    serviceResult.setSuccess(true);
    serviceResult.setMessage(mensaje);
    serviceResult.setRegistros(registros);
    serviceResult.setData(datos);
    
    return serviceResult;
  }
  
}
