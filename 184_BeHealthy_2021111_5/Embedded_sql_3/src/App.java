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
            System.out.println("Enter number of days for which profit is to be viewed:");
            int days=sc.nextInt();
            sc.close();

            rs = stmt.executeQuery("with net_order_value(val) as\n"+ 
            "(select sum(net_amount)\n"+
            "from invoice\n"+
            "where datediff(now(), date) <= "+days+"),\n"+
            "net_cost_value(val) as\n"+
            "(select sum(cost_price*invoice_details.quantity)\n"+
            "from invoice_details inner join medicine_inventory using (mid, lot_number)\n"+
            "where bill_id in (\n"+
            "select bill_id\n"+
            "from invoice\n"+
            "where datediff(now(), date) <= "+days+"))\n"+
            "select net_order_value.val as net_order, net_cost_value.val as net_cost, net_order_value.val - net_cost_value.val as net_profit\n"+
            "from net_order_value, net_cost_value;");
        
            System.out.println("net_order   net_cost   net_profit");
            while(rs.next()){
                int net_order=rs.getInt(1);
                int net_cost=rs.getInt(2);
                int net_profit=rs.getInt(3);
                System.out.println(net_order+"       "+net_cost+"     "+net_profit);
            }
        }
        catch (SQLException ex){
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
