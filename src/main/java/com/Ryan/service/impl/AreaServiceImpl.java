package com.Ryan.service.impl;

import com.Ryan.entity.area.Area;
import com.Ryan.mapper.AreaMapper;
import com.Ryan.service.AreaService;
import com.Ryan.vo.AreaVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AreaServiceImpl implements AreaService {

    @Autowired
    public AreaMapper areaMapper;
    @Override
    public Integer count() {
        return areaMapper.count();
    }

    @Override
    public List<AreaVo> areasList() {
        List<AreaVo> areasList = areaMapper.areasList();
        return areasList;
    }


    @Override
    public boolean existsByName(String name) {
        return areaMapper.countByName(name) > 0;
    }

    @Override
    public void createArea(Area area) {
        areaMapper.createArea(area);
    }

    @Override
    public void updateAreaById(Area area) {
        areaMapper.updateAreaById(area);
    }

    @Override
    public void deleteAreaById(Integer id) {
        areaMapper.deleteAreaById(id);
    }

    @Override
    public Integer getIdByName(String name) {
        return areaMapper.getIdByName(name);
    }

    @Override
    public String getNameById(Integer id) {

        return areaMapper.getNameById(id);
    }

    @Override
    public List<Area> getAllAreas() {
        // 调用mapper层
        return areaMapper.getAllAreas();
    }


}
