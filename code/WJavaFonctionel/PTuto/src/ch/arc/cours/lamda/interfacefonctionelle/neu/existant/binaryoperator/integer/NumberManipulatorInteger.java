
package ch.arc.cours.lamda.interfacefonctionelle.neu.existant.binaryoperator.integer;

import java.util.function.IntBinaryOperator;

public class NumberManipulatorInteger
	{

	/*------------------------------------------------------------------*\
	|*							Methodes Public							*|
	\*------------------------------------------------------------------*/

	/**
	 * see chapter stream to see beautiful flexible optimized code
	 */
	public static int reduce(int[] tab, IntBinaryOperator operator, int initValue)
		{
		int value = initValue;
		for(int element:tab)
			{

			value = operator.applyAsInt(value, element);

			}

		return value;
		}

	/*------------------------------------------------------------------*\
	|*							Methodes Private						*|
	\*------------------------------------------------------------------*/

	}
