package com.washtrack.washtrack_api.proceso.respository;

import com.washtrack.washtrack_api.proceso.entity.ProcesosEntity;
import com.washtrack.washtrack_api.proceso.response.ProcesosResponseRepository;

public interface IProcesosRepository {
  ProcesosResponseRepository insertarProcesoRepository(ProcesosEntity proceso);
  ProcesosResponseRepository actualizarProcesoRepository(ProcesosEntity proceso);
  ProcesosResponseRepository eliminarProcesoRepository(String  idproceso, String tenantid);
  ProcesosResponseRepository buscarProcesoRepository(String codigoProceso, String tenantid);
  ProcesosResponseRepository listarProcesosRepository(String tenantid);
}
