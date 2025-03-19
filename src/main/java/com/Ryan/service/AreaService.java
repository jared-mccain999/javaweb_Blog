package com.Ryan.service;

import com.Ryan.entity.area.Area;
import com.Ryan.vo.AreaVo;

import java.util.List;

public interface AreaService {

    Integer count();

    List<AreaVo> areasList();

    boolean existsByName(String name);

    void createArea(Area area);

    void updateAreaById(Area area);

    void deleteAreaById(Integer id);

    Integer getIdByName(String name);

    String getNameById(Integer id) ;
}
