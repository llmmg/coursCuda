
package ch.arc.cours.lamda.interfacefonctionelle.neu.existant.function;

import java.util.function.Function;

import ch.arc.cours.lamda.interfacefonctionelle.neu.existant.function.tools.Maison;

public class UseFunctionMap
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
		System.out.println("map : Function");

		mapping();
		}

	private static void mapping()
		{
		int prix = 1;
		int nbPiece = 2;
		int surface = 3;
		Maison maison = new Maison(prix, nbPiece, surface);

		printSurface(maison);
		printPrix(maison);
		printPiece(maison);
		}

	/*------------------------------------------------------------------*\
	|*							Methodes Private						*|
	\*------------------------------------------------------------------*/

	private static void mapPrint(Maison maison, Function<Maison, Integer> function)
		{

		Integer attribut = function.apply(maison);

		System.out.println(attribut);
		}

	/*------------------------------*\
	|*				lamda			*|
	\*------------------------------*/

	private static void printSurface(Maison maison)
		{
		// version : classe interne anonyme
			{
			mapPrint(maison, new Function<Maison, Integer>()
				{

				@Override
				public Integer apply(Maison t)
					{
					return t.getSurface();
					}
				});
			}

		// Version : lamda dans variable
			{
			//----------------------------------on ne veut que la surface de la maison
			Function<Maison, Integer> surface = maisoon -> maison.getSurface();

			mapPrint(maison, surface);

			}

		// Version : lamda
			{
			mapPrint(maison, house -> maison.getSurface());
			}
		}

	private static void printPiece(Maison maison)
		{
		// Version : lamda
			{
			mapPrint(maison, house -> maison.getNbPiece());
			}
		}

	private static void printPrix(Maison maison)
		{
		// Version : lamda
			{
			mapPrint(maison,house -> maison.getPrix());
			}
		}

	}
