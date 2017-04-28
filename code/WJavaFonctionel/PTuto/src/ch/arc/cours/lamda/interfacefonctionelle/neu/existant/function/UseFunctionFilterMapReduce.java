
package ch.arc.cours.lamda.interfacefonctionelle.neu.existant.function;

import java.util.List;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.function.Predicate;

import org.junit.Assert;

import ch.arc.cours.lamda.interfacefonctionelle.neu.existant.function.tools.Maison;
import ch.arc.cours.lamda.interfacefonctionelle.neu.existant.function.tools.MaisonTools;

public class UseFunctionFilterMapReduce
	{

	/*------------------------------------------------------------------*\
	|*							Methodes Public							*|
	\*------------------------------------------------------------------*/

	public static void main(String[] args)
		{
		main();
		}

	public static void main()
		{
		System.out.println("filter map Reduce : Predicate Function binaryOperator ");

		filterMapReduce();
		}

	/*------------------------------------------------------------------*\
	|*							Methodes Private						*|
	\*------------------------------------------------------------------*/

	private static void filterMapReduce()
		{
		int n = 4;
		List<Maison> list = MaisonTools.create(n);

		int sum1 = version1(list);
		int sum2 = version2(list);
		int sum3 = version3(list);

		System.out.println(list);

		check(list, sum1);
		check(list, sum2);
		check(list, sum3);
		}

	/**
	 * somme des prix des maisons dont nbPiece>20
	 *
	 * Classe Interne anonyme
	 */
	private static int version1(List<Maison> list)
		{
		Predicate<Maison> pieceBiggerThan20 = new Predicate<Maison>()
			{

			@Override
			public boolean test(Maison t)
				{
				// TODO Auto-generated method stub
				return t.getNbPiece() > 20;
				}
			};

		Function<Maison, Integer> price = new Function<Maison, Integer>()
			{

			@Override
			public Integer apply(Maison t)
				{
				// TODO Auto-generated method stub
				return t.getPrix();
				}
			};

		BinaryOperator<Integer> sum = new BinaryOperator<Integer>()
			{

			@Override
			public Integer apply(Integer t, Integer u)
				{
				// TODO Auto-generated method stub
				return t + u;
				}
			};

		return MaisonManipulator.filterMapReduce(list, pieceBiggerThan20, price, sum, 0);
		}

	/*------------------------------*\
	|*				lamda			*|
	\*------------------------------*/

	/**
	 * somme des prix des maisons dont nbPiece>20
	 *
	 * lamda dans variable
	 */
	private static int version2(List<Maison> list)
		{
		Predicate<Maison> pieceBiggerThan20 = maison -> maison.getNbPiece() > 20;
		Function<Maison, Integer> price = maison -> maison.getPrix();

		return MaisonManipulator.filterMapReduce(list, pieceBiggerThan20, price, (a, b) -> a + b, 0);
		}

	/**
	 * somme des prix des maisons dont nbPiece>20
	 *
	 * lamda
	 */
	private static int version3(List<Maison> list)
		{
		return MaisonManipulator.filterMapReduce(list, maison -> maison.getNbPiece() > 20, maison -> maison.getPrix(), (a, b) -> a + b, 0);
		}

	/*------------------------------*\
	|*				Tools			*|
	\*------------------------------*/

	private static void check(List<Maison> list, int sum)
		{
		System.out.println("sum prix = " + sum);

		Assert.assertTrue(sum == 7);
		}

	}
