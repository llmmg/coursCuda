
package ch.arc.cours.lamda.interfacefonctionelle.neu.custom.function.compose;

import org.junit.Assert;

import ch.arc.cours.lamda.interfacefonctionelle.neu.custom.function.Function_I;

public class UseCompose
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
		System.out.println("Compose");

		useComposition1();
		useComposition2();
		useComposition3();
		}

	/*------------------------------------------------------------------*\
	|*							Methodes Private						*|
	\*------------------------------------------------------------------*/

	/**
	 * x -> x*x+1
	 *
	 * h(x)= x+1
	 * g(x)= x*x
	 * (g o h) (x)= h(g(x))
	 *
	 * Classe interne anonyme
	 */
	private static void useComposition1()
		{

		Function_I h = new Function_I()
			{

			@Override
			public double value(double x)
				{
				// TODO Auto-generated method stub
				return x +1;
				}
			};

		Function_I g = new Function_I()
			{

			@Override
			public double value(double x)
				{
				// TODO Auto-generated method stub
				return x *x;
				}
			};

		Function_I u1 = FunctionCompose.composition1(h, g);
		Function_I u2 = FunctionCompose.composition2(h, g);
		Function_I u3 = FunctionCompose.composition3(h, g);

		check(u1, u2, u3);
		}

	/**
	 * x -> x*x+1
	 *
	 * h(x)= x+1
	 * g(x)= x*x
	 * (g o h) (x)= h(g(x))
	 *
	 * lamda dans variable
	 */
	private static void useComposition2()
		{
		// TODO
		Function_I h = x -> x + 1;
		Function_I g = x -> x * x;

		Function_I u1 = FunctionCompose.composition1(h, g);
		Function_I u2 = FunctionCompose.composition2(h, g);
		Function_I u3 = FunctionCompose.composition3(h, g);

		check(u1, u2, u3);
		}

	/**
	 * x -> x*x+1
	 *
	 * h(x)= x+1
	 * g(x)= x*x
	 * (g o h) (x)= h(g(x))
	 *
	 * lamda
	 */
	private static void useComposition3()
		{

		Function_I u1 = FunctionCompose.composition1(x -> x + 1, x -> x * x);
		Function_I u2 = FunctionCompose.composition2(x -> x + 1, x -> x * x);
		Function_I u3 = FunctionCompose.composition3(x -> x + 1, x -> x * x);

		check(u1, u2, u3);
		}

	/*------------------------------*\
	|*				Tools			*|
	\*------------------------------*/

	private static void check(Function_I u1, Function_I u2, Function_I u3)
		{
		System.out.println(u1.value(2));
		System.out.println(u2.value(2));
		System.out.println(u3.value(2));

//		Assert.assertTrue(u1.value(2) == 2 * 2 + 1);
//		Assert.assertTrue(u2.value(2) == 2 * 2 + 1);
//		Assert.assertTrue(u3.value(2) == 2 * 2 + 1);
		Assert.assertTrue(u1.value(2) == 2 + 2 * 1);
		Assert.assertTrue(u2.value(2) == 2 + 2 * 1);
		Assert.assertTrue(u3.value(2) == 2 + 2 * 1);
		}

	}
