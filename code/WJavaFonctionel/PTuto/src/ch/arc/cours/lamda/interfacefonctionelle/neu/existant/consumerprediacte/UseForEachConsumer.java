
package ch.arc.cours.lamda.interfacefonctionelle.neu.existant.consumerprediacte;

import java.util.function.Consumer;

import ch.arc.cours.lamda.interfacefonctionelle.neu.existant.consumerprediacte.tools.Homme;
import ch.arc.cours.lamda.interfacefonctionelle.neu.existant.consumerprediacte.tools.HommeTools;

public class UseForEachConsumer
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
		System.out.println("foreach : Consumer");

		foreach();
		}

	/*------------------------------------------------------------------*\
	|*							Methodes Private						*|
	\*------------------------------------------------------------------*/

	private static void foreach()
		{
		int n = 5;

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

		System.out.println("Before : " + iterable);

		HommeManipulator.foreach(iterable, new Consumer<Homme>()
			{

			@Override
			public void accept(Homme t)
				{
				// TODO Auto-generated method stub
				t.opposePoids();
				}
			});

		System.out.println("After  : " + iterable);
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

		Consumer<Homme> inverseWeight = homme -> homme.opposePoids();
//		Consumer<Homme> taille = homme -> System.out.println(homme.getHauteur());

		HommeManipulator.foreach(iterable, inverseWeight);

		System.out.println("After  : " + iterable);
		}

	/**
	 * lamda
	 */
	private static void version3(int n)
		{
		Iterable<Homme> iterable = HommeTools.create(n);

		HommeManipulator.foreach(iterable, homme -> homme.opposePoids());

		System.out.println("After  : " + iterable);
		}

	}
