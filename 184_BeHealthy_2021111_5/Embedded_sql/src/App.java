import java.sql.*;
import java.util.Scanner;

public class App {
    public static void main(String[] args) throws Exception {
        Connection conn = null;
        try {
            conn =
               DriverManager.getConnection("jdbc:mysql://localhost:3306/?"+"user=root&password=vibhor1234");
        
        
        } catch (SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }    
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            stmt = conn.createStatement();
            stmt.execute("use behealthy;");
            
            Scanner sc = new Scanner(System.in);
            System.out.println("Enter customer id:");
            int cid=sc.nextInt();
            System.out.println("Enter number of days for customer history period:");
            int days=sc.nextInt();
            sc.close();

            rs = stmt.executeQuery("select mid, sum(quantity) as monthly_order\n"+
            "from invoice_details\n"+
            "where bill_id=(\n"+
            "select bill_id\n"+
            "from invoice where cid="+cid+" and datediff(now(), date) <="+days+" )\n"+
            "group by mid\n"+
            "order by monthly_order desc;");
                    
            System.out.println("mid  tot_quantity for last "+days+" days"); //order_quantity            
            while(rs.next()){
                int mid=rs.getInt(1);
                int tot_quantity=rs.getInt(2);
                System.out.println(mid+"      "+tot_quantity);
            }
        }
        catch (SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        finally {
        
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqlEx) { }
        
                rs = null;
            }
        
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) { }
        
                stmt = null;
            }
        }
    }
}
