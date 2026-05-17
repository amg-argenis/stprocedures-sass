package com.washtrack.washtrack_api.proceso.service;

import com.washtrack.washtrack_api.proceso.dto.ProcesoUpdateRequest;
import com.washtrack.washtrack_api.proceso.dto.ProcesosRequest;
import com.washtrack.washtrack_api.util.response.ServiceResult;

public interface IProcesosService {
  ServiceResult<Object> insertarProcesoService(ProcesosRequest procesosRequest);
  ServiceResult<Object> actualizarProcesoService(ProcesoUpdateRequest procesosRequest);
  ServiceResult<Object> eliminarProcesoService(String idproceso, String tenantid);
  ServiceResult<Object> buscarProcesoService(String codigoProceso, String tenantid);
  ServiceResult<Object> listarProcesoService(String tenantid);
}
