# Buttons

*Anyone taken Software 1? Can you help me figure out what this weird Java program does?*

---

用[javadecompilers](http://www.javadecompilers.com/)反编译`Buttons.jar`得到源码.

观察到有一个`printFlag`函数,但是依赖于`moveHistory`,所以不能通过直接运行`printFlag`来得到flag.

分析调用`printFlag`函数的`actionPerformed`,发现:只有当前点击的方格是`isLegalMove`的时候,才会被加到`moveHistory`里;当前点击的方格是最后一个时就会打印出`flag`.

继续分析`isLegalMove`函数,发现该函数返回为`True`时必须满足`grid[n][n2] == 0`.

那么我们可以在初始化的时候,将所有满足`grid[n][n2] == 0`的方格设为🏁,然后依次点击显示为🏁的方格即可.

```java
this.buttons[i][j] = new JButton("?");

if(this.grid[i][j] == 0){
  this.buttons[i][j].setText("\u2691");
}
```
使用`javac`命令将源代码编译为Java字节码文件并运行.

```shell
╭─ ~/CTF/BuckeyeCTF2021
╰─$ javac Buttons.java
注: Buttons.java使用了未经检查或不安全的操作。
注: 有关详细信息, 请使用 -Xlint:unchecked 重新编译。
╭─ ~/CTF/BuckeyeCTF2021
╰─$ java Buttons
```

![Buttons!](../../CTF/BuckeyeCTF2021/Reverse/images/Buttons.png)

代码

```java
/*
 * Decompiled with CFR 0.150.
 */
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

public final class Buttons
extends JFrame
implements ActionListener {
    private static final int[][] grid = new int[][]{
        {1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
        {1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1},
        {1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1},
        {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        {1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1}, 
        {1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1},
        {1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1},
        {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1},
        {1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1},
        {1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
        {1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1},
        {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1}
    };
    private final int rows;
    private final int cols;
    private final JLabel movesLabel;
    private final JButton resetButton;
    private final JButton[][] buttons;
    private int posRow;
    private int posCol;
    private final int endRow;
    private final int endCol;
    private static final int MAX_MOVES = 139;
    private ArrayList<Integer> moveHistory;

    public static void main(String[] arrstring) throws Exception {
        new Buttons();
    }

    public Buttons() {
        super("Buttons!");
        this.resetValues();
        this.rows = grid.length;
        this.cols = grid[0].length;
        this.endRow = this.rows - 1;
        this.endCol = this.cols - 2;
        JPanel jPanel = new JPanel();
        jPanel.setLayout(new BoxLayout(jPanel, 3));
        JPanel jPanel2 = new JPanel(new GridLayout(this.rows, this.cols));
        JPanel jPanel3 = new JPanel();
        this.buttons = new JButton[this.rows][this.cols];
        for (int i = 0; i < this.rows; ++i) {
            for (int j = 0; j < this.cols; ++j) {
                this.buttons[i][j] = new JButton("?");

              	if(this.grid[i][j] == 0) {
  								this.buttons[i][j].setText("\u2691");
								}

                this.buttons[i][j].addActionListener(this);
                this.buttons[i][j].setActionCommand(Integer.toString(j + i * this.cols));
                jPanel2.add(this.buttons[i][j]);
            }
        }
        this.buttons[this.endRow][this.endCol].setText("\u2691");
        jPanel2.setPreferredSize(new Dimension(45 * this.rows, 45 * this.cols));
        this.movesLabel = new JLabel("Moves left: 20");
        jPanel3.add(this.movesLabel);
        this.resetButton = new JButton("Reset");
        this.resetButton.addActionListener(this);
        this.resetButton.setActionCommand("reset");
        jPanel3.add(this.resetButton);
        jPanel.add(jPanel2);
        jPanel.add(jPanel3);
        this.resetGUI();
        this.getContentPane().add(jPanel);
        this.pack();
        this.setDefaultCloseOperation(3);
        this.setVisible(true);
    }

    private void resetValues() {
        this.posRow = 0;
        this.posCol = 1;
        this.moveHistory = new ArrayList();
        this.moveHistory.add(this.posCol + this.posRow * this.cols);
    }

    private void updateMovesLeft() {
        this.movesLabel.setText("Moves left: " + Integer.toString(139 - this.moveHistory.size()));
    }

    private void resetGUI() {
        for (int i = 0; i < this.rows; ++i) {
            for (int j = 0; j < this.cols; ++j) {
                this.buttons[i][j].setEnabled(true);
            }
        }
        for (int j : this.moveHistory) {
            int n = j / this.cols;
            int n2 = j % this.cols;
            this.buttons[n][n2].setEnabled(false);
        }
        this.updateMovesLeft();
    }

    private void reset() {
        this.resetValues();
        this.resetGUI();
    }

    private boolean isLegalMove(int n, int n2) {
        if (139 - this.moveHistory.size() <= 0) {
            return false;
        }
        return grid[n][n2] == 0 && Math.abs(n - this.posRow) + Math.abs(n2 - this.posCol) == 1;
    }

    private void printFlag() {
        BigInteger bigInteger;
        BigInteger[] arrbigInteger = new BigInteger[this.moveHistory.size()];
        arrbigInteger[0] = BigInteger.valueOf(2L);
        for (int i = 1; i < arrbigInteger.length; ++i) {
            arrbigInteger[i] = arrbigInteger[i - 1].nextProbablePrime();
        }
        BigInteger bigInteger2 = BigInteger.valueOf(1L);
        BigInteger bigInteger3 = new BigInteger("1430313837704837266267655033918654049072573502772041995300810633148485540425442305963378206448908414865491202671058946396326575688430628383447817933039379");
        for (int i = 0; i < this.moveHistory.size(); ++i) {
            bigInteger = BigInteger.valueOf(this.moveHistory.get(i).intValue());
            bigInteger2 = bigInteger2.multiply(arrbigInteger[i].modPow(bigInteger, bigInteger3)).mod(bigInteger3);
        }
        BigInteger bigInteger4 = new BigInteger("1181624346478884506978387685027501257422054115549381320819711748725513305918055802813085700551988448885328987653245675378090761255233757606571908411691314");
        bigInteger = bigInteger4.multiply(bigInteger2).mod(bigInteger3);
        byte[] arrby = bigInteger.toByteArray();
        String string = new String(arrby, StandardCharsets.UTF_8);
        JOptionPane.showMessageDialog(this, "Congrats! The flag is: " + string, "Flag", 1);
        System.out.println(string);
    }

    @Override
    public void actionPerformed(ActionEvent actionEvent) {
        String string = actionEvent.getActionCommand();
        if (string.equals("reset")) {
            this.reset();
        } else {
            int n;
            int n2 = Integer.parseInt(string);
            int n3 = n2 / this.cols;
            if (this.isLegalMove(n3, n = n2 % this.cols)) {
                this.buttons[n3][n].setEnabled(false);
                this.posRow = n3;
                this.posCol = n;
                this.moveHistory.add(n2);
                System.out.println(this.moveHistory);
                this.updateMovesLeft();
                if (this.posRow == this.endRow && this.posCol == this.endCol) {
                    this.printFlag();
                }
            } else {
                JOptionPane.showMessageDialog(this, "Illegal move, you lose \u2639", "Illegal move", 0);
                this.reset();
            }
        }
    }
}
```

**flag:**`buckeye{am4z1ng_j0b_y0u_b1g_j4va_h4ck3r}`

