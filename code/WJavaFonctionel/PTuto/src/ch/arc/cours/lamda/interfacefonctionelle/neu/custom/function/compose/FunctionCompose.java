
package ch.arc.cours.lamda.interfacefonctionelle.neu.custom.function.compose;

import ch.arc.cours.lamda.interfacefonctionelle.neu.custom.function.Function_I;

public class FunctionCompose
	{

	/*------------------------------------------------------------------*\
	|*							Methodes Public							*|
	\*------------------------------------------------------------------*/

	/**
	 * (h 0 g)(x) = g(h(x))
	 *
	 * classe interne anonyme
	 */
	public static Function_I composition1(Function_I h, Function_I g)
		{
		return new Function_I()
			{

			@Override
			public double value(double x)
				{
				// TODO Auto-generated method stub
				return g.value(h.value(x));
				}
			};

		}

	/**
	 * (h 0 g)(x) = g(h(x))
	 *
	 * lamda dans variable
	 */
	public static Function_I composition2(Function_I h, Function_I g)
		{

		Function_I comp = x -> g.value(h.value(x));
		return comp;
		}

	/**
	 * (h 0 g)(x) = g(h(x))
	 *
	 * lamda
	 */
	public static Function_I composition3(Function_I h, Function_I g)
		{
		return x -> g.value(h.value(x));
		}

	/*------------------------------------------------------------------*\
	|*							Methodes Private						*|
	\*------------------------------------------------------------------*/

	}
