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
            System.out.println("Enter number of days for which medicine frequency is to be viewed:");
            int days=sc.nextInt();
            sc.close();

            rs = stmt.executeQuery("with most_freq(val) as\n"+
            "(select max(med_count)\n"+
            "from(\n"+
            "select mid, count(*)\n"+
            "from invoice_details\n"+
            "where bill_id in (\n"+
            "select bill_id\n"+
            "from invoice\n"+
            "where datediff(now(), date) <= "+days+")\n"+
            "group by mid\n"+
            ") as med_info(mid, med_count))\n"+
            "select med_info.mid, name, med_info.med_count as bill_count\n"+
            "from medicine_details, most_freq, (\n"+
            "select mid, count(*)\n"+
            "from invoice_details\n"+
            "where bill_id in (\n"+
            "select bill_id\n"+
            "from invoice\n"+
            "where datediff(now(), date) <= "+days+")\n"+
            "group by mid\n"+
            ") as med_info(mid, med_count)\n"+
            "where med_info.med_count=most_freq.val and medicine_details.mid=med_info.mid;");
        
            System.out.println("mid   name        bill_count");
            while(rs.next()){
                int mid=rs.getInt(1);
                String name=rs.getString(2);
                int bill_count=rs.getInt(3); //order_count
                System.out.println(mid+"   "+name+"   "+bill_count);
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