/*
NAME: Mark Kaganovsky
S#: 100963794

EMAIL: markkaganovsky@cmail.carleton.com
COURSE: COMP3007 - Programming Paridigms
SEMESTER: Fall 2018
PROFESSOR: Dr. Robert Collier

Assignment 1 - Question 1
*/

import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class comp3007_f18_100963794_a1_1 {
	public static void main(String args[]){
		/* 
		 * Test Strings:
		 *     is tHis eXaMPLe SUFfIcIEntLY TELliNG
		 *     Have YOU tRieD ThE HotDOGs?
		 *     the camel acrostic of this string should be CAOTSSBC
		 *     aPPle
		 *     aPplE BanANA
		 */
		
		Scanner scanner = new Scanner(System.in);
		String input = "";
		while(!input.equals("quit")) {
			System.out.println("Enter a string to compute Camel Acrostic, or 'quit': ");
			input = scanner.nextLine();
			System.out.println(toCamelAcrostic(toCamelCase(Arrays.asList(input.split("\\s")))));
		}
		scanner.close();
	}
	
	public static char toLowerCase(char c){
		return c >= 65 && c <= 90 ? (char)(c+32) : c;
	}
	
	private static String toLowerCase(String s){
		return s.length() >= 1 ? toLowerCase(s.charAt(0)) + toLowerCase(s.substring(1)) : s;
	}
	
	public static char toUpperCase(char c){
		return c >= 97 && c <= 122 ? (char)(c-32) : c;
	}
	
	public static String toTitleCase(String s){
		return s.length() >= 1 ? toUpperCase(s.charAt(0)) + toLowerCase(s.substring(1)) : s;
	}
	
	public static boolean isUpper(char c) {
		return c >= 65 && c <= 90;
	}
	
	public static String toCamelCase(List<String> strings) {
		if(strings == null || strings.size() == 0) {
			return "";
		}
		else if(strings.size() == 1) {
			return toLowerCase(strings.get(0));
		}
		else {
			return toCamelCase(strings.subList(0, strings.size()-1)) + toTitleCase(strings.get(strings.size()-1));
		}
	}
	
	public static String toCamelAcrostic(String s) {
		if(s.length() > 0) {
			return isUpper(s.charAt(0)) ? s.charAt(0) + toCamelAcrostic(s.substring(1)) : toCamelAcrostic(s.substring(1));
		}
		return "";
	}
}