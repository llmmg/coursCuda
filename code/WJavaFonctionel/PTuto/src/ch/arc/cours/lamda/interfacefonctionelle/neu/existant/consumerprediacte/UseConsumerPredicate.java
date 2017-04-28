
package ch.arc.cours.lamda.interfacefonctionelle.neu.existant.consumerprediacte;

import java.util.function.Consumer;
import java.util.function.Predicate;

import ch.arc.cours.lamda.interfacefonctionelle.neu.existant.consumerprediacte.tools.Homme;
import ch.arc.cours.lamda.interfacefonctionelle.neu.existant.consumerprediacte.tools.HommeTools;

public class UseConsumerPredicate
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
		System.out.println("foreach & filter: Consumer & Predicate");

		foreachFilter();
		}

	private static void foreachFilter()
		{
		int n = 5;

		version1(n);

		// lamda
			{
			version2(n);
			version3(n);
			}
		}

	/*------------------------------------------------------------------*\
	|*							Methodes Private						*|
	\*------------------------------------------------------------------*/

	private static void version1(int n)
		{
		Iterable<Homme> iterable = HommeTools.create(n);

		Predicate<Homme> biggerThan50 = new Predicate<Homme>()
			{

			@Override
			public boolean test(Homme t)
				{
				return t.getHauteur() > 50;
				}
			};

		Consumer<Homme> InverseWeigth = new Consumer<Homme>()
			{

			@Override
			public void accept(Homme t)
				{
				t.opposePoids();
				}
			};

		HommeManipulator.filterForeach(iterable, biggerThan50, InverseWeigth);

		System.out.println(iterable);
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

		Predicate<Homme> biggerThan50 = homme -> homme.getHauteur() > 50;
		Consumer<Homme> InverseWeigth = homme -> homme.opposePoids();

		HommeManipulator.filterForeach(iterable, biggerThan50, InverseWeigth);

		System.out.println(iterable);
		}

	/**
	 * lamda
	 */
	private static void version3(int n)
		{
		Iterable<Homme> iterable = HommeTools.create(n);

		HommeManipulator.filterForeach(iterable, homme -> homme.getHauteur() > 50, homme -> homme.opposePoids());

		System.out.println(iterable);
		}

	}
