package com.washtrack.washtrack_api.proceso.response;

import com.washtrack.washtrack_api.proceso.entity.ProcesosEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class ProcesosResponseRepository {
  private Integer codigobd;
  private ProcesosEntity procesosEntity;
  private List<ProcesosEntity> entityList;
}
