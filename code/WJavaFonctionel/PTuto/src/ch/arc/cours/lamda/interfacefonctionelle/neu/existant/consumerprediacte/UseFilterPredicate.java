
package ch.arc.cours.lamda.interfacefonctionelle.neu.existant.consumerprediacte;

import java.util.function.Predicate;

import ch.arc.cours.lamda.interfacefonctionelle.neu.existant.consumerprediacte.tools.Homme;
import ch.arc.cours.lamda.interfacefonctionelle.neu.existant.consumerprediacte.tools.HommeTools;

public class UseFilterPredicate
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
		System.out.println("filter : Predicate");

		filter();
		}

	/*------------------------------------------------------------------*\
	|*							Methodes Private						*|
	\*------------------------------------------------------------------*/

	private static void filter()
		{
		int n = 10;

		version1(n);

		// lamda
			{
			version2(n);
			version3(n);
			}
		}

	private static void version1(int n)
		{
		Iterable<Homme> iterable = HommeTools.create(n);

		//Display list to check filter
		System.out.println(iterable);

		// TODO
		Iterable<Homme> iterableFiltrer = HommeManipulator.filter(iterable, new Predicate<Homme>()
			{

			@Override
			public boolean test(Homme homme)
				{
				return homme.getHauteur() > 50;
				}
			});

		System.out.println(iterableFiltrer);
		}

	/*------------------------------*\
	|*				lamda			*|
	\*------------------------------*/

	/**
	 * lamda dans variable
	 */
	private static void version2(int n)
		{
		Iterable<Homme> iterable = HommeTools.create(n);

		// TODO
		Predicate<Homme> heightBigger50 = homme -> homme.getHauteur() > 50;
//		Predicate<Homme> heightBigger50 = homme -> {return homme.getHauteur()->50};

		Iterable<Homme> iterableFiltrer = HommeManipulator.filter(iterable, heightBigger50);

		System.out.println(iterableFiltrer);
		}

	/**
	 * lamda
	 */
	private static void version3(int n)
		{
		Iterable<Homme> iterable = HommeTools.create(n);

		// TODO

		Iterable<Homme> iterableFiltrer = HommeManipulator.filter(iterable, homme -> homme.getHauteur() > 50);

		System.out.println(iterableFiltrer);
		}

	}
