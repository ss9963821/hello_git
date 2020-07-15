import java.util.Arrays;

public class TEST {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int[] scores = {99,97,98};
		Arrays.sort(scores);
		
		for(int i=0; i<scores.length; i++) {
			System.out.println("scores[" + i + "]=" + scores[i]);
		}
		System.out.println();
		
		String[] names = {"梯團熱", "夢翕熱", "�垮瘚�"};
		Arrays.parallelSort(names);
		
		for(int i=0; i<names.length; i++) {
			System.out.println("name[" + i +"]=" + names[i]);
		}
		System.out.println();
		System.out.println();
		System.out.println("GitHub modify 8 line");
		System.out.println("PULL modify 8 line");
	}

}

