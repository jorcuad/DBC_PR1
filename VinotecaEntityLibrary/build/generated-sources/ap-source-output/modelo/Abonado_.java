package modelo;

import javax.annotation.Generated;
import javax.persistence.metamodel.CollectionAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import modelo.Persona;
import modelo.Preferencia;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2015-11-18T18:01:50")
@StaticMetamodel(Abonado.class)
public class Abonado_ { 

    public static volatile SingularAttribute<Abonado, String> password;
    public static volatile CollectionAttribute<Abonado, Preferencia> preferenciaCollection;
    public static volatile SingularAttribute<Abonado, Integer> numeroabonado;
    public static volatile SingularAttribute<Abonado, Persona> nif;
    public static volatile SingularAttribute<Abonado, String> login;

}