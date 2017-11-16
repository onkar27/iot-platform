package org.kyantra.resources;

import io.swagger.annotations.Api;
import org.hibernate.Session;
import org.kyantra.beans.CredentialBean;
import org.kyantra.beans.SessionBean;
import org.kyantra.beans.UserBean;
import org.kyantra.dao.UserDAO;

import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Path("auth")
@Api("auth")
public class AuthResource extends BaseResource {

    @POST
    @Path("basic")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Produces(MediaType.APPLICATION_JSON)
    public String authenticate(@FormParam("email") String email, @FormParam("password") String password){

        CredentialBean credentialBean = new CredentialBean();
        credentialBean.setEmail(email);
        credentialBean.setPassword(password);

        // Based on
        // https://stackoverflow.com/questions/26777083/best-practice-for-rest-token-based-authentication-with-jax-rs-and-jersey
        if(credentialBean.getEmail()!=null
                && credentialBean.getPassword()!=null){
            //do db based auth and if it is true then Create a new SessionBean for this user.
            //Generate new String token using UUID
            SessionBean sessionBean = new SessionBean();
            //TODO complete the getByEmail method in DAO. -Done
            UserBean userBean = UserDAO.getInstance().getByEmail(credentialBean.getEmail());

            if(userBean.getPassword().equals(credentialBean.getPassword())) {

                sessionBean.setUser(userBean);
                sessionBean.setToken(UUID.randomUUID().toString());
                //user is expected to save this session token in cookie or some place and pass it with every
                //future request where authentication is neccessary.
                //True REST apis are stateless and this token is what will mimick statefulness for us.
                //now check the Filter code.
                Session session = getSession();
                session.save(sessionBean);
                session.close();

                return gson.toJson(sessionBean);
            }
        }

        Map<String,String> map = new HashMap<>();
        return gson.toJson(map); //suggests failed authentication.
    }


}
