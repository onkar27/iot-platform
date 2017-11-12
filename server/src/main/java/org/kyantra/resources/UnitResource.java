package org.kyantra.resources;

import io.swagger.annotations.Api;
import org.kyantra.beans.UnitBean;
import org.kyantra.dao.UnitDAO;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

/**
 * Created by Lenovo on 12-11-2017.
 */
@Path("/unit")
@Api(value="unit")
public class UnitResource extends BaseResource {

    @GET
    @Path("get/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public String get(@PathParam("id") Integer id){
        UnitBean unitBean = UnitDAO.getInstance().get(id);
        return gson.toJson(unitBean);
    }

    @POST
    @Path("update/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public String update(@PathParam("id") Integer id, UnitBean unitBean){
        UnitDAO.getInstance().update(id,unitBean.getUnitName(),unitBean.getDescription(),unitBean.getPhoto(),
                unitBean.getParent(), unitBean.getSubunits());
        unitBean = UnitDAO.getInstance().get(unitBean.getId());
        return gson.toJson(unitBean);
    }

    @DELETE
    @Path("delete/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public String delete(@PathParam("id") Integer id){
        try {
            UnitDAO.getInstance().delete(id);
            return "{}";
        }catch (Throwable t) {
            t.printStackTrace();
        }
        return "{}";
    }

    @POST
    @Path("create")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public String create(UnitBean unitBean){
        try {
            String s = "Found something";
            System.out.println(gson.toJson(unitBean));
            UnitBean unit = UnitDAO.getInstance().add(unitBean);
            return gson.toJson(unit);

        }catch (Throwable t){
            t.printStackTrace();
        }
        return "{\"success\":false}";
    }
}
